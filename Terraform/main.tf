resource "azurerm_resource_group" "resource-group" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "virtual-network" {
  depends_on=[azurerm_resource_group.resource-group]
  
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource-group.name}"
}

resource "azurerm_subnet" "subnet" {
  depends_on=[azurerm_virtual_network.virtual-network]
  
  name                 = "${var.prefix}-snet"
  resource_group_name  = "${azurerm_resource_group.resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.virtual-network.name}"
  address_prefix       = "10.0.2.0/24"
}
resource "azurerm_public_ip" "public-IP" {
    depends_on=[azurerm_resource_group.resource-group]
  
    name                         = "${var.prefix}-pip"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.resource-group.name}"
    allocation_method            = "Static"
}
resource "azurerm_network_security_group" "network-security-group" {
    depends_on=[azurerm_resource_group.resource-group]
  
    name                = "${var.prefix}-nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.resource-group.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_rule" "access-webapp" {
  depends_on=[azurerm_resource_group.resource-group,azurerm_network_security_group.network-security-group]
  
  name = "Port_8080"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "8080"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = "${azurerm_resource_group.resource-group.name}"
  network_security_group_name = "${azurerm_network_security_group.network-security-group.name}"
}

resource "azurerm_network_interface" "nic" {
  depends_on                = [azurerm_subnet.subnet,azurerm_public_ip.public-IP]
  
  name                      = "${var.prefix}-nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.resource-group.name}"
  # network_security_group_id = "${azurerm_network_security_group.network-security-group.id}"
  
  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public-IP.id}"
  }
}
resource "azurerm_network_interface_security_group_association" "example" {
    depends_on                = [azurerm_network_interface.nic,azurerm_network_security_group.network-security-group]
  
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.network-security-group.id
}
resource "azurerm_virtual_machine" "virtual-machine" {
    depends_on            = [azurerm_network_interface.nic]
  
    name                  = "${var.prefix}-vm"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.resource-group.name}"
    vm_size               = "Basic_A1"
    network_interface_ids = [azurerm_network_interface.nic.id]
 

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name         = "ubuntu"
    admin_username        = "prod-webapp"
    admin_password        = "prodwebapp@123"
    custom_data           = file("initial-boot.txt")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
