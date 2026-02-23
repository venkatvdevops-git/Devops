variable "topic_name" { type = string }
variable "project_id" { type = string }
variable "labels"     { type = map(string); default = { env = "dev" } }

variable "subscriptions" {
  type = map(object({
    ack_deadline = number
  }))
  default = {}
}