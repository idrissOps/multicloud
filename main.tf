# Configuration du provider Azure
provider "azurerm" {
  features {}
}

# Configuration du provider AWS
provider "aws" {
  region = "us-east-1"
}

# Ressources Azure en multiicloud
resource "azurerm_virtual_machine" "azureServ1" {

}

# Ressources AWS en multicloud
resource "aws_instance" "example" {

}