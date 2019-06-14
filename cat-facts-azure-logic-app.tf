variable organization_name = "Your organization's name"
variable distribution_list_email_address = "catfacts@domain.com"
variable your_name = "Macaulay Culkin"
variable boss_name = "Joe Pesci"

resource "azurerm_resource_group" "cat-facts-app" {
  name     = "cat-facts-${var.environment_name}"
  location = "canadacentral"
}

resource "azurerm_logic_app_workflow" "cat-facts-workflow" {
  name                = "Cat-Facts-App"
  location            = "${azurerm_resource_group.cat-facts-app.location}"
  resource_group_name = "${azurerm_resource_group.cat-facts-app.name}"
  parameters          = {
    "$connections" = ""
  }
}

resource "azurerm_logic_app_trigger_recurrence" "cat-facts-trigger" {
  name         = "Run every 5 minutes"
  logic_app_id = "${azurerm_logic_app_workflow.cat-facts-workflow.id}"
  frequency    = "Minute"
  interval     = 5
}

resource "azurerm_logic_app_action_http" "cat-facts-api-request" {
  name         = "Get new cat fact"
  logic_app_id = "${azurerm_logic_app_workflow.cat-facts-workflow.id}"
  method       = "GET"
  uri          = "https://catfact.ninja/fact"
}

resource "azurerm_logic_app_action_custom" "cat-facts-initialize-variable" {
  name         = "Initialize_variable"
  logic_app_id = "${azurerm_logic_app_workflow.cat-facts-workflow.id}"

  body = <<BODY
{
    "description": "A variable to house the fact",
    "inputs": {
        "variables": [
            {
                "name": "CatFact",
                "type": "String",
                "value": "@body('Parse_JSON')?['fact']"
            }
        ]
    },
    "runAfter": {
        "Parse_JSON": [
            "Succeeded"
        ]
    },
    "type": "InitializeVariable"
}
BODY
}

resource "azurerm_logic_app_action_custom" "cat-facts-parse-json" {
  name         = "Parse_JSON"
  logic_app_id = "${azurerm_logic_app_workflow.cat-facts-workflow.id}"

  body = <<BODY
{
    "description": "Parse the JSON we get from the Cat Facts API",
    "inputs": {
        "content": "@body('Get new cat fact')",
        "schema": {
            "properties": {
                "fact": {
                    "type": "string"
                },
                "length": {
                    "type": "integer"
                }
            },
            "type": "object"
        }
    },
    "runAfter": {
        "Get new cat fact": [
            "Succeeded"
        ]
    },
    "type": "ParseJson"
}
BODY
}

resource "azurerm_logic_app_action_custom" "cat-facts-send-email" {
  name         = "Send_an_email_(V2)"
  logic_app_id = "${azurerm_logic_app_workflow.cat-facts-workflow.id}"

  body = <<BODY
{
    "description": "Deliver the cat fact",
    "inputs": {
        "body": {
            "Body": "<p><span style=\"font-size: 14px\"><strong>Thank you for subscribing to Cat Facts, ${var.organization_name}'s most trusted resource of feline-related information in the Greater [CITY] Area!</strong></span><br>\n<br>\nDid you know:<br>\n@{variables('CatFact')}<br>\n<span style=\"font-size: 10px\">Source: </span><a href=\"http://catfact.ninja/fact\"><span style=\"font-size: 10px\">catfact.ninja/fact</span></a><br>\n<br>\nWant more Cat Facts? Just wait 5 minutes and you'll get another one!<br>\n<br>\nWant to not receive more Cat Facts? &nbsp;<strong>TOO BAD.</strong><br>\n<br>\n<span style=\"font-size: 10px\">This fact was obtained and submitted via the \"Cat-Facts-App\" Azure Logic App, meticulously designed and implemented by ${var.your_name}. &nbsp;If you have any questions, comments, concerns, or general complaints, please direct them to his boss ${var.boss_name} for immediate disposal.</span></p>",
            "Subject": "[IMPORTANT] Cat Fact!",
            "To": "${var.distribution_list_email_address}"
        },
        "host": {
            "connection": {
                "name": "@parameters('$connections')['office365']['connectionId']"
            }
        },
        "method": "post",
        "path": "/v2/Mail"
    },
    "runAfter": {
        "Initialize_variable": [
            "Succeeded"
        ]
    },
    "type": "ApiConnection"
}
BODY
}
