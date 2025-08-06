variable "location" {
  default = "eastus"
}

variable "rg_name" {
  default = "RG_main_${var.location}_${var.environment}"
}

variable "environment" {
  default = "dev1"
}