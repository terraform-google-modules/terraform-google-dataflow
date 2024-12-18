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

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 10.0"
  project_id   = var.project_id
  network_name = "dataflow-network"

  subnets = [
    {
      subnet_name   = "dataflow-subnetwork"
      subnet_ip     = "10.1.3.0/24"
      subnet_region = "us-central1"
    },
  ]

  secondary_ranges = {
    dataflow-subnetwork = [
      {
        range_name    = "my-secondary-range"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]
  }
}

module "dataflow-bucket" {
  source  = "terraform-google-modules/dataflow/google//modules/dataflow_bucket"
  version = "~> 2.0"

  name          = local.gcs_bucket_name
  region        = var.region
  project_id    = var.project_id
  force_destroy = var.force_destroy
}

module "dataflow-job" {
  source  = "terraform-google-modules/dataflow/google"
  version = "~> 2.0"

  project_id            = var.project_id
  name                  = "wordcount-terraform-example"
  on_delete             = "cancel"
  region                = var.region
  zone                  = var.zone
  max_workers           = 1
  template_gcs_path     = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location     = module.dataflow-bucket.name
  service_account_email = var.service_account_email
  network_self_link     = module.vpc.network_self_link
  subnetwork_self_link  = module.vpc.subnets_self_links[0]
  machine_type          = "n1-standard-1"

  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://${local.gcs_bucket_name}/output/my_output"
  }
}

module "dataflow-job-2" {
  source                = "terraform-google-modules/dataflow/google"
  version               = "~> 2.0"
  project_id            = var.project_id
  name                  = "wordcount-terraform-example-2"
  on_delete             = "cancel"
  region                = var.region
  zone                  = var.zone
  max_workers           = 1
  template_gcs_path     = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location     = module.dataflow-bucket.name
  service_account_email = var.service_account_email
  network_self_link     = module.vpc.network_self_link
  subnetwork_self_link  = module.vpc.subnets_self_links[0]
  machine_type          = "n1-standard-2"

  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://${local.gcs_bucket_name}/output/my_output"
  }

  labels = {
    example_name = "simple_example"
  }
}

