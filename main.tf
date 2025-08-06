resource "azurerm_resource_group" "rg_main" {
  name     = var.rg_name
  location = var.location
}

module "vnet" {
    location = var.location
    rg_name = azurerm_resource_group.rg_main.name
    source = "./modules/vnet"
    depends_on = [ azurerm_resource_group.rg_main ]
}

module "cluster" {
    location = var.location
    rg_name = azurerm_resource_group.rg_main.name
    subnet_id = module.vnet.subnet_id
    source = "./modules/cluster"
    depends_on = [ module.vnet, module.NSG ]
}

module "NSG" {
    location = var.location
    rg_name = azurerm_resource_group.rg_main.name
    subnet_id = module.vnet.subnet_id
    source = "./modules/NSG"
    depends_on = [ module.vnet ]
}

# module "namespaces" {
#   source      = "./modules/namespaces"
#   depends_on  = [module.cluster]
# }

# module "monitoring" {
#   source               = "./modules/helm"
#   monitoring_namespace = module.namespaces.monitoring_namespace
#   kube_config          = module.cluster.kube_config
#   depends_on           = [module.namespaces, module.cluster]
# }


provider "kubernetes" {
    host                   = module.cluster.kube_config.0.host
    client_certificate     = base64decode(module.cluster.kube_config.0.client_certificate)
    client_key             = base64decode(module.cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(module.cluster.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes = {
      host                   = module.cluster.kube_config.0.host
      client_certificate     = base64decode(module.cluster.kube_config.0.client_certificate)
      client_key             = base64decode(module.cluster.kube_config.0.client_key)
      cluster_ca_certificate = base64decode(module.cluster.kube_config.0.cluster_ca_certificate)
  }
}