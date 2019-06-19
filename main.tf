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

resource "google_dataflow_job" "dataflow_job" {
  provider              = "google"
  project               = "${var.project_id}"
  zone                  = "${var.zone}"
  name                  = "${var.name}"
  on_delete             = "${var.on_delete}"
  max_workers           = "${var.max_workers}"
  template_gcs_path     = "${var.template_gcs_path}"
  temp_gcs_location     = "gs://${var.temp_gcs_location}/tmp_dir"
  parameters            = "${var.parameters}"
  service_account_email = "${var.service_account_email}"
  network               = "${replace(var.network_self_link, "/(.*)/networks/(.*)/", "$2")}"
  subnetwork            = "${replace(var.subnetwork_self_link, "/(.*)/regions/(.*)/", "regions/$2")}"
  machine_type          = "${var.machine_type}"
}
