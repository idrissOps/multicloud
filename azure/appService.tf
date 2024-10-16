# Configurer le fournisseur Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}

  subscription_id = "12345678-1234-1234-1234-123456789012"
  client_id       = "abcd1234-ab12-cd34-ef56-abcdef123456"
  client_secret   = ""
  tenant_id       = "12345678-90ab-cdef-1234-567890abcdef"
}

# Générer un entier aléatoire pour créer un nom unique
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Créer le groupe de ressources
resource "ApplicationGroup" "rg" {
  name     = "myResourceGroup-${random_integer.ri.result}"
  location = "canadacentral-01"
}

# Créer le plan App Service Linux
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = ApplicationGroup.rg.location
  resource_group_name = ApplicationGroup.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Créer l'application web
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-${random_integer.ri.result}"
  location            = ApplicationGroup.rg.location
  resource_group_name = ApplicationGroup.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
  }
}

# Déployer le code depuis un dépôt GitHub public
resource "azurerm_app_service_source_control" "sourcecontrol" {
  name                  = "ApplicationTest"
  resource_group_name   = ApplicationGroup
  app_id                = 
  repo_url              = "https://github.com/idrissOps/AppMulticloudTest.git"
  branch                = "master"
  use_manual_integration = true
}
