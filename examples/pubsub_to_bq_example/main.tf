/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  region = var.region
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

locals {
  gcs_bucket_name = "tmp-dir-bucket-${random_id.random_suffix.hex}"
}

module "dataflow-bucket" {
  source  = "terraform-google-modules/dataflow/google//modules/dataflow_bucket"
  version = "~> 2.0"

  name          = local.gcs_bucket_name
  region        = var.region
  project_id    = var.project_id
  force_destroy = var.force_destroy
}

resource "google_pubsub_topic" "topic" {
  name    = var.topic_name
  project = var.project_id
}

resource "google_pubsub_subscription" "pull_subscriptions" {
  name                       = var.pull_subscription_name
  project                    = var.project_id
  topic                      = google_pubsub_topic.topic.id
  message_retention_duration = "1200s"
  retain_acked_messages      = true
  ack_deadline_seconds       = 20
  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }
  enable_message_ordering = false
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id    = var.dataset_id
  friendly_name = var.dataset_name
  project       = var.project_id
  description   = "This is a test description"
  location      = "US"


  labels = {
    env = "default"
  }
}

resource "google_bigquery_table" "table" {
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  table_id            = var.table
  project             = var.project_id
  deletion_protection = var.deletion_protection
  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
    [
    {
        "name": "data",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "The Permalink"
    }
    ]
  EOF
}


module "dataflow" {
  source  = "terraform-google-modules/dataflow/google"
  version = "~> 2.0"

  project_id            = var.project_id
  name                  = "pubsub-to-bq-terraform-example-job"
  region                = "us-central1"
  on_delete             = "drain"
  zone                  = "us-central1-a"
  max_workers           = 1
  template_gcs_path     = "gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery"
  temp_gcs_location     = module.dataflow-bucket.name
  service_account_email = var.service_account_email
  network_self_link     = "default"
  subnetwork_self_link  = ""
  machine_type          = "n1-standard-1"

  parameters = {
    inputSubscription = "projects/${var.project_id}/subscriptions/${google_pubsub_subscription.pull_subscriptions.name}"
    outputTableSpec   = "${var.project_id}:${google_bigquery_dataset.dataset.dataset_id}.${google_bigquery_table.table.table_id}"
  }
}
