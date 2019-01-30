# This Terraform configuration will create the following:
#
# This will create a Resource group with a virtual network and subnet
# It will also create a centos Virtual Machine
# All Variables are pulled from Variables.tf


# Resource Group
resource "azurerm_resource_group" "usnc-centos-test" {
    name = "${var.resourcegroup}"
    location = "${var.location}"
    tags {
        Environment = "CentOS Terraform Deployment"
    }
}

resource "azurerm_virtual_network" "usnc-teds-vnet" {
    name = "${var.virtualnetwork}"
    location = "${var.location}"
    address_space = ["${var.address_space}"]
    resource_group_name = "${azurerm_resource_group.usnc-centos-test.name}"
    tags {
        Environment = "CentOS Terraform Deployment"
    }
}

resource "azurerm_subnet" "subnet" {
    name = "${var.prefix}-subnet"
    virtual_network_name = "${azurerm_virtual_network.usnc-teds-vnet.name}"
    address_prefix ="${var.address_prefix}"
    resource_group_name = "${azurerm_resource_group.usnc-centos-test.name}"
}

resource "azurerm_network_security_group" "usnc-teds-nsg" {
    name = "${var.prefix}-nsg"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.usnc-centos-test.name}"
    
    security_rule {
    name = "HTTP"
    priority = 100
    direction ="Inbound"
    access = "allow"
    protocol = "tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "${var.source_network}"
    destination_address_prefix = "*"
    }

    security_rule {
    name = "ssh"
    priority = 101
    direction = "Inbound"
    access = "allow"
    protocol = "tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "${var.source_network}"
    destination_address_prefix = "*"
    }

    tags {
        Environment = "CentOS Terraform Deployment"
    }
}
resource "azurerm_network_interface" "usnc_centos_nic" {
    name = "${var.prefix}usnc_centos_nic"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.usnc-centos-test.name}"
    network_security_group_id = "${azurerm_network_security_group.usnc-teds-nsg.id}"


    ip_configuration {
        name = "${var.prefix}ipconfig"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = "${azurerm_public_ip.usnc_centos_pip.id}"
    }

    tags {
        Environment = "CentOS Terraform Deployment"
    }
}


resource "azurerm_public_ip" "usnc_centos_pip" {
    name = "${var.prefix}-ip"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.usnc-centos-test.name}"
    public_ip_address_allocation = "Dynamic"
    domain_name_label = "${var.hostname}"

    tags {
        Environment = "CentOS Terraform Deployment"
    }
}

resource "azurerm_virtual_machine" "usnc-centos-vm" {
    name = "${var.hostname}-centos"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.usnc-centos-test.name}"
    vm_size = "${var.vmsize}"
    network_interface_ids =  ["${azurerm_network_interface.usnc_centos_nic.id}"]

#Use AZ Cli to find list of images like so
#az vm image list --output table
    storage_image_reference {
        publisher = "OpenLogic"
        offer = "CentOS"
        sku = "7.5"
        version = "latest"
    }
    storage_os_disk {
        name = "${var.hostname}-osdisk"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name = "${var.hostname}"
        admin_username = "${var.username}"
        admin_password = "${var.password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }    

    tags {
        Environment = "CentOS Terraform Deployment"
    }

}




