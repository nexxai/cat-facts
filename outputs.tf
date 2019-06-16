output "cat_fact_workflow_id" {
  description = "The workflow ID of this azure cat fact logic workflow"
  value       = "${azurerm_logic_app_workflow.cat-facts-workflow.id}"
}
