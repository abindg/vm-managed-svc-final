variable "vmname" {
   description = "Contains the name of the VM where the managed actions are to be performed"
    type = string
    }

variable "startaction" {
    description = "Contains the decision whether to start the selected vm"
    type = bool
    }

variable "stopaction" {
    description = "Contains the decision whether stop the selected vm"
    type = bool
    }

variable "adddisk" {
    description = "Contains the decision whether to add a new data disk"
    type = bool
    }

variable "existingdiskcount" {
    description = "Contains the number of existing data disks in the VM"
    type = number
    }

variable "disksize" {
    description = "size of data disk to be added"
    type = number
    }

variable "diskcount" {
    description = "number of managed data disks to add"
    type = number
    }

variable "chgsize" {
    description = "contains the decision whether to change a vm size"
    type = bool
    }

variable "diskprefix" {
    description = "Contains the disk name prefix"
    type = string
    }

variable "vmsize" {
    description = "contains the new size of vm"
    type = string
    }

variable "resourcegroupname" {
    description = "contains the rg"
    type = string
}

variable "resourcegrouplocation" {
  description = "contains the location"
  type = string
  default = "eastus"
}