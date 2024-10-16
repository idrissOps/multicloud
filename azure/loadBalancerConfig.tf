provider "azurerm" {
  features {}

  subscription_id = "12345678-1234-1234-1234-123456789012"
  client_id       = "abcd1234-ab12-cd34-ef56-abcdef123456"
  client_secret   = ""
  tenant_id       = "12345678-90ab-cdef-1234-567890abcdef"
}

resource "ApplicationGroup" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "mynet" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = ApplicationGroup.location
  resource_group_name = ApplicationGroup.name
}

resource "azurerm_subnet" "mysubnet" {
  name                 = "example-subnet"
  resource_group_name  = ApplicationGroup.name
  virtual_network_name = ApplicationGroup.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "ipaddresspub" {
  name                = "example-pip"
  location            = ApplicationGroup.location
  resource_group_name = ApplicationGroup.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb1" {
  name                = "lb1"
  location            = ApplicationGroup.location
  resource_group_name = ApplicationGroup.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "example-frontend"
    public_ip_address_id = azurerm_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "example-backend-pool"
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.id
  name            = "lb_probe_"
  protocol        = "Tcp"
  port            = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id            = azurerm_lb.example.id
  name                       = "example-rule"
  protocol                   = "Tcp"
  frontend_port              = 80
  backend_port               = 80
  frontend_ip_configuration  = "example-frontend"
  backend_address_pool_id    = azurerm_lb_backend_address_pool.example.id
  probe_id                   = azurerm_lb_probe.example.id
}
