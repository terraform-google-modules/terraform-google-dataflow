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

output "name" {
  description = "The name of the dataflow job"
  value       = google_dataflow_flex_template_job.dataflow_job.name
}

output "container_spec_gcs_path" {
  description = "The GCS path to the Dataflow job Flex Template."
  value       = google_dataflow_flex_template_job.dataflow_job.container_spec_gcs_path
}

output "temp_location" {
  description = "The Cloud Storage path to use for temporary files. Must be a valid Cloud Storage URL, beginning with gs://."
  value       = google_dataflow_flex_template_job.dataflow_job.temp_location
}

output "state" {
  description = "The state of the newly created Dataflow job"
  value       = google_dataflow_flex_template_job.dataflow_job.state
}

output "id" {
  description = "The unique Id of the newly created Dataflow job"
  value       = google_dataflow_flex_template_job.dataflow_job.id
}
