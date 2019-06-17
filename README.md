# cat-facts
A Terraform template for annoying your friends and/or co-workers with Cat Facts every 5 minutes


You will need to update the 5 variables at the top of the file with the appropriate values as well as create a connection to Office 365 using the account you wish to email from.

There is no way to add the O365 connection after this workflow app has been provisioned. Currently the module will sleep for a configurable 60 seconds, allowing the user time to open the Azure console, go to the newly created Cat-Facts-App and manually add a step that will create an O365 connection. I recommend the "Get Calendars" task as it doesn't require any additional configuration. Once this is completed the final logic app action will be deployed and will automatically use the newly created O365 connection.

## Module usage
```terraform
module "MY_TEST_CATFACT" {
  source = "github.com/WarpRat/cat-facts"

  organization_name               = "Contoso"
  distribution_list_email_address = "root@whitehouse.gov"
  location                        = "WestUS2"
  city                            = "Seattle"
  your_name                       = "Macaulay Culkin"
  boss_name                       = "Joe Pesci"
}
```