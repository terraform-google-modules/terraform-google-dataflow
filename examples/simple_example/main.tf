/**
 * Copyright 2018 Google LLC
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
  version = "~> 2.0"
  region  = "${var.region}"
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

locals {
  gcs_bucket_name = "tmp-dir-bucket-${random_id.random_suffix.hex}"
}

module "dataflow-bucket" {
  source     = "../../modules/dataflow_bucket"
  name       = "${local.gcs_bucket_name}"
  region     = "${var.region}"
  project_id = "${var.project_id}"
}

module "dataflow-job" {
  source                = "../../"
  project_id            = "${var.project_id}"
  name                  = "wordcount-terraform-example"
  on_delete             = "cancel"
  zone                  = "${var.region}-a"
  max_workers           = 1
  template_gcs_path     = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location     = "${module.dataflow-bucket.name}"
  service_account_email = "${var.service_account_email}"

  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://${local.gcs_bucket_name}/output/my_output"
  }
}

module "dataflow-job-2" {
  source                = "../../"
  project_id            = "${var.project_id}"
  name                  = "wordcount-terraform-example-2"
  on_delete             = "cancel"
  zone                  = "${var.region}-a"
  max_workers           = 1
  template_gcs_path     = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location     = "${module.dataflow-bucket.name}"
  service_account_email = "${var.service_account_email}"

  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://${local.gcs_bucket_name}/output/my_output"
  }
}
