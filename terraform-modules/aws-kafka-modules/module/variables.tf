variable "cloud_provider" {
  type        = string
  description = "Choose: aws, gcp, or azure"
  validation {
    condition     = contains(["aws", "gcp", "azure"], var.cloud_provider)
    error_message = "Cloud provider must be one of: aws, gcp, azure."
  }
}

variable "resource_name" {
  type        = string
  description = "The base name for the Kafka topic/EventHub/PubSub topic"
}

# Cloud-specific variables (Optional based on provider)
variable "aws_vpc_id"     { default = null }
variable "gcp_project_id" { default = null }
variable "azure_rg"       { default = null }