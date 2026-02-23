# 1. Main Topic
resource "google_pubsub_topic" "main" {
  name   = var.topic_name
  labels = var.labels
}

# 2. Dead Letter Topic (For failed messages)
resource "google_pubsub_topic" "dead_letter" {
  name = "${var.topic_name}-dlq"
}

# 3. Dynamic Subscriptions
resource "google_pubsub_subscription" "subs" {
  for_each = var.subscriptions
  
  name  = each.key
  topic = google_pubsub_topic.main.name
  
  ack_deadline_seconds = each.value.ack_deadline
  
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter.id
    max_delivery_attempts = 5
  }
}

# 4. IAM: Allow Pub/Sub to publish to its own DLQ
resource "google_pubsub_topic_iam_member" "dlq_publisher" {
  topic  = google_pubsub_topic.dead_letter.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

data "google_project" "current" {}