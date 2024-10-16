provider "azurerm" {
  features {}

  subscription_id = "12345678-1234-1234-1234-123456789012"
  client_id       = "abcd1234-ab12-cd34-ef56-abcdef123456"
  client_secret   = "your_client_secret_here"
  tenant_id       = "12345678-90ab-cdef-1234-567890abcdef"
}

resource "azurerm_resource_group" "terraformAzureRessources" {
  name     = "MesApplications"
  location = "West Europe"
}
