# --- AWS DEPLOYMENT ---
module "aws_streaming" {
  source       = "./modules/msk"
  count        = var.cloud_provider == "aws" ? 1 : 0
  
  cluster_name = var.resource_name
  vpc_id       = var.aws_vpc_id
  subnet_ids   = var.aws_subnets
}

# --- GCP DEPLOYMENT ---
module "gcp_streaming" {
  source     = "./modules/pubsub"
  count      = var.cloud_provider == "gcp" ? 1 : 0
  
  topic_name = var.resource_name
  project_id = var.gcp_project_id
}

# --- AZURE DEPLOYMENT ---
module "azure_streaming" {
  source              = "./modules/eventhubs"
  count               = var.cloud_provider == "azure" ? 1 : 0
  
  namespace_name      = "${var.resource_name}-ns"
  eventhub_name       = var.resource_name
  resource_group_name = var.azure_rg
  location            = var.azure_location
}