# Configuration du fournisseur Azure
provider "azurerm" {
  features {}
}

# Création d'un groupe de ressources
resource "azurerm_resource_group" "Groupe1" {
  name     = "my-resource-group"
  location = "us-east-1"
}

# Création d'un réseau virtuel
resource "azurerm_virtual_network" "example" {
  name                = "my-virtual-network"
  address_space       = [""]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Création d'un sous-réseau
resource "azurerm_subnet" "subNet1" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Création d'une machine virtuelle 

resource "azurerm_virtual_machine" "example" {
  name                  = "my-vm"
  resource_group_name  = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  network_interface_ids = [azurerm_network_interface.example.id]
  
  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    managed_disk {
      storage_account_id = azurerm_storage_account.example.id
    }
  }
  hardware_profile {
    num_cores = 1
    vm_size   = "Standard_DS1_v2"
  }
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  os_profile {
    computer_name  = "my-vmBenServer"
    admin_username = "adminuser"
    admin_password = "BenRoot"
  }
}

# Création d'une interface réseau pour trafic du pipelines

resource "azurerm_network_interface" "example" {
  name                  = "my-nic"
  location              = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                    = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}