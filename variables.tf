variable "location" {
  default = "eastus_DON'T_USE_DEFAULTS"
}

variable "rg_name" {
  default = "ASSIGNED_AUTOMATICALLY"
}
#RG_main_${var.location}_${var.environment}

variable "environment" {
  default = "dev1_DON'T_USE_DEFAULTS"
}