variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "namespace_name"      { type = string }
variable "eventhub_name"       { type = string }
variable "partition_count"     { default = 2 }
variable "message_retention"   { default = 1 }