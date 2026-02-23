variable "cluster_name" { type = string }
variable "vpc_id"       { type = string }
variable "subnet_ids"   { type = list(string) }
variable "kafka_version" { default = "3.5.1" }
variable "instance_type" { default = "kafka.m5.large" }
variable "client_sg_id"  { description = "SG of the Jenkins/App instances" }