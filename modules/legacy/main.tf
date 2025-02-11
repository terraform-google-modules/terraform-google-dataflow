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

resource "google_dataflow_job" "dataflow_job" {
  project                = var.project_id
  name                   = var.name
  template_gcs_path      = var.template_gcs_path
  temp_gcs_location      = "gs://${var.temp_gcs_location}/tmp_dir"
  on_delete              = var.on_delete
  region                 = var.region
  max_workers            = var.max_workers
  parameters             = var.parameters
  service_account_email  = var.service_account_email
  network                = var.network_name
  subnetwork             = var.subnetwork
  machine_type           = var.machine_type
  ip_configuration       = var.use_public_ips ? "WORKER_IP_PUBLIC" : "WORKER_IP_PRIVATE"
  enable_streaming_engine = var.enable_streaming_engine
  skip_wait_on_job_termination = var.skip_wait_on_job_termination
  additional_experiments = var.additional_experiments
  kms_key_name           = var.kms_key_name
  labels                 = var.labels
}

