##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "resourcegroup" {
    description = " The name of your Azure Resource Group"
    default = "usnc-centos-tfrg12"
}

variable "prefix" {
    description = "This prefix will be appended to certain resources"
    default = "centostf"
}
variable "hostname" {
    description = "This is the name of your virtual machine"
    default = "usnc-centos-vm1"
}

variable "location" {
    description = "The region you locate your Azure resources"
    default = "northcentralus"
}

variable "virtualnetwork" {
    description = "The name of your virtual network"
    default = "usnc-centosvm1-vnet"
}

variable "address_space" {
    description = "Top level networking schema"
    default = "10.0.0.0/16"
}

variable "address_prefix" {
    description = "Local LAN Network"
    default = "10.0.1.0/24"
}

variable "source_network" {
    description = "Inbound traffic to NSG"
    default = "173.24.111.189"
}

variable "vmsize" {
    description = "Type of VM Series available on Azure Marketplace"
    default = "Standard_DS2_v2"
}

variable "username" {
    description = "The username you will use to authenticate into your VM"
    default = "testuser"
}

variable "password" {
    description = "The password you will use to authenticate into your VM"
    default = "Password.1"
}

