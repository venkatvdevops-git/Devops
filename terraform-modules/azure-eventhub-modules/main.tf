# 1. Create the Event Hubs Namespace (The Cluster)
resource "azurerm_eventhub_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1  # Base Throughput Units

  # Pro-Level: Auto-scaling
  auto_inflate_enabled     = true
  maximum_throughput_units = 10

  tags = { environment = "Production" }
}

# 2. Create the Event Hub (The Topic)
resource "azurerm_eventhub" "this" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

# 3. Create a Shared Access Policy (For Kafka Clients)
resource "azurerm_eventhub_authorization_rule" "kafka_client" {
  name                = "kafka-app-policy"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}