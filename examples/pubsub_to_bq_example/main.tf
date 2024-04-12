/**
 * Copyright 2024 Google LLC
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

# provider "google" {
#   region = var.region
# }

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

module "dataflow" {
  source  = "terraform-google-modules/dataflow/google"
  version = "~>2.4.0"

  project_id             = var.project_id
  name                   = var.name
  zone                   = var.zone
  on_delete              = var.on_delete
  max_workers            = var.max_workers
  template_gcs_path      = "gs://${var.template_gcs_path}/templates/{PASS THE NAME OF THE MODULE}"
  temp_gcs_location      = module.dataflow-bucket.name
  service_account_email  = var.service_account_email
  network_self_link      = var.network_self_link
  subnetwork_self_link   = var.subnetwork_self_link
  machine_type           = var.machine_type
  ip_configuration       = var.ip_configuration
  kms_key_name           = var.kms_key_name
  labels                 = var.labels
  additional_experiments = var.additional_experiments
  parameters             = var.parameters
}

