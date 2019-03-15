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

provider "google" {}

resource "random_id" "random_suffix" {
  byte_length = 4
}

module "dataflow-job" {
  source      = "../../"
  project_id  = "${var.project_id}"
  job_name = "${var.job_name}"
  on_delete = "cancel"
  zone = "us-central1-a"
  max_workers = 1
  template_gcs_path =  "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location = "tmp-dir-bucket-${random_id.random_suffix.hex}"
  #temp_gcs_location = "${var.temp_gcs_location}"
}