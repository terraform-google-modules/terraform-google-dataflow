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
variable "project_id" {
  description = "The project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "name" {
  description = "The name of the dataflow job"
}

variable "template_gcs_path" {
  description = "The GCS path to the Dataflow job template."
}

variable "temp_gcs_location" {
  description = "A writeable location on GCS for the Dataflow job to dump its temporary data."
}

variable "parameters" {
  description = "Key/Value pairs to be passed to the Dataflow job (as used in the template)."
  default     = {}
}

variable "max_workers" {
  description = " The number of workers permitted to work on the job. More workers may improve processing speed at additional cost."
  default     = "1"
}

variable "on_delete" {
  description = "One of drain or cancel. Specifies behavior of deletion during terraform destroy. The default is cancel."
  default     = "cancel"
}

variable "zone" {
  description = "The zone in which the created job should run. If it is not provided, the provider zone is used."
  default     = "us-central1-a"
}

variable "service_account_email" {
  description = "The Service Account email that will be used to identify the VMs in which the jobs are running"
  default     = ""
}

variable "region" {
  description = "The bucket's region location"
  default     = "us-central1"
}

variable "subnetwork_self_link" {
  description = "The subnetwork self link to which VMs will be assigned."
  default     = ""
}

variable "network_name" {
  description = "The name of the network to which VMs will be assigned."
  default     = "default"
}

variable "machine_type" {
  description = "The machine type to use for the job."
  default     = ""
}
