
data "azurerm_resource_group" "rg" {
  name = var.resourcegroupname
}

data "azurerm_resources" "managed_vm" {
   name = var.vmname
   }

locals {
  vm_present = length(data.azurerm_resources.managed_vm.resources)
  start_action = var.startaction ? 1 : 0
  stop_action = var.stopaction ? 1 : 0
  add_disk = length(data.azurerm_resources.managed_vm.resources) > 0 ? var.adddisk : false
  chg_size = length(data.azurerm_resources.managed_vm.resources) > 0 ? var.chgsize : false
}

# managed service to stop a VM when VM is present and stop service is set to true
resource "null_resource" "stop_srvc" {
    count = "${local.stop_action * local.vm_present}"
    provisioner "local-exec" {
        command = "az vm stop --resource-group ${data.azurerm_resource_group.rg.name} --name ${var.vmname}"
         interpreter = ["PowerShell", "-Command"]
}
}

# managed service to start a VM when VM is present and start service is set to true
resource "null_resource" "start_srvc1" {
    count = "${local.start_action * local.vm_present}"
    provisioner "local-exec" {
        command = "az vm start -g ${data.azurerm_resource_group.rg.name} -n ${var.vmname}"
         interpreter = ["PowerShell", "-Command"]
}
}

# Managed service to create new data disks for attachment with linuxvm when vm is present and adddisk is set to true
resource "azurerm_managed_disk" "mngd_disk" {
  count = local.add_disk ? var.diskcount : 0
  name                 = "${var.diskprefix}-${count.index + var.existingdiskcount }"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disksize
}

resource "azurerm_virtual_machine_data_disk_attachment" "vmdiskattach" {
  count = local.add_disk ? var.diskcount : 0
  managed_disk_id    = local.vm_present > 0 ? element(azurerm_managed_disk.mngd_disk[*].id,count.index) : ""
  virtual_machine_id = data.azurerm_resources.managed_vm.resources[0].id
  lun                = "${count.index + var.existingdiskcount + 10}"
  caching            = "ReadWrite"
}

# Manage Service to resize a vm when vm is present and chgsize boolean is set to true

resource "null_resource" "resize_vm" {
    count = local.chg_size ? 1 : 0
    provisioner "local-exec" {
        command = "az vm resize -g ${data.azurerm_resource_group.rg.name} -n ${var.vmname} --size ${var.vmsize}"
         interpreter = ["PowerShell", "-Command"]
}
}







