# ── Resource Group ───────────────────────────────────────────────────────────

resource "azurerm_resource_group" "az_rg" {
  name     = "az-resource-group"
  location = var.resource_group_location
}

# ── Network ──────────────────────────────────────────────────────────────────

resource "azurerm_virtual_network" "az_nt" {
  name                = "VNet"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = azurerm_resource_group.az_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "az_sb" {
  name                 = "AzSubnet"
  resource_group_name  = azurerm_resource_group.az_rg.name
  virtual_network_name = azurerm_virtual_network.az_nt.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "az_pb_ip" {
  name                = "azPublicIp"
  location            = azurerm_resource_group.az_rg.location
  resource_group_name = azurerm_resource_group.az_rg.name
  # Standard SKU (default) requires Static allocation
  allocation_method = "Static"
}

resource "azurerm_network_interface" "az_intf" {
  name                = "azintf"
  location            = azurerm_resource_group.az_rg.location
  resource_group_name = azurerm_resource_group.az_rg.name

  ip_configuration {
    name                          = "IPconfig"
    subnet_id                     = azurerm_subnet.az_sb.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.az_pb_ip.id
  }
}

# ── Linux Virtual Machine ────────────────────────────────────────────────────

resource "azurerm_linux_virtual_machine" "az_vm" {
  name                            = "az-deployed"
  resource_group_name             = azurerm_resource_group.az_rg.name
  location                        = azurerm_resource_group.az_rg.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "azadmin"
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.az_intf.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
