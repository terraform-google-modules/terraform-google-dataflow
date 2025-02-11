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
variable "project_id" {
  type        = string
  description = "The project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "name" {
  type        = string
  description = "The name of the dataflow job"
}

variable "container_spec_gcs_path" {
  type        = string
  description = "The GCS path to the Dataflow job Flex Template."
}

variable "temp_location" {
  type        = string
  description = "The Cloud Storage path to use for temporary files. Must be a valid Cloud Storage URL, beginning with gs://."
  default = null
}

variable "on_delete" {
  type        = string
  description = "One of drain or cancel. Specifies behavior of deletion during terraform destroy. The default is cancel."
  default     = "cancel"
}

variable "region" {
  type        = string
  description = "The region in which the created job should run. Also determines the location of the staging bucket if created."
  default     = "us-central1"
}

variable "max_workers" {
  type        = number
  description = " The number of workers permitted to work on the job. More workers may improve processing speed at additional cost."
  default     = 1
}

variable "service_account_email" {
  type        = string
  description = "The Service Account email that will be used to identify the VMs in which the jobs are running"
  default     = ""
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to which VMs will be assigned. If provided, it should be of the form of 'regions/REGION/subnetworks/SUBNETWORK'."
  default     = ""
}

variable "network_name" {
  type        = string
  description = "The network to which VMs will be assigned."
  default     = "default"
}

variable "launcher_machine_type" {
  type        = string
  description = "The machine type to use for launching the job."
  default     = ""
}

variable "machine_type" {
  type        = string
  description = "The machine type to use for the job."
  default     = ""
}

variable "sdk_container_image" {
  type        = string
  description = "Docker registry location of container image to use for the 'worker harness. Default is the container for the version of the SDK. Note this field is only valid for portable pipelines."
  default     = null
}

variable "use_public_ips" {
  type        = bool
  description = "Specifies whether Dataflow workers use external IP addresses. If the value is set to false, Dataflow workers use internal IP addresses for all communication."
  default     = false
}

variable "enable_streaming_engine" {
  type        = bool
  description = "Enable/disable the use of Streaming Engine for the job."
  default     = false
}

variable "autoscaling_algorithm" {
  type        = string
  description = "The algorithm to use for autoscaling."
  default     = null
}

variable "skip_wait_on_job_termination" {
  type        = bool
  description = "If set to true, terraform will treat DRAINING and CANCELLING as terminal states when deleting the resource, and will remove the resource from terraform state and move on."
  default     = false
}

variable "kms_key_name" {
  type        = string
  description = "The name for the Cloud KMS key for the job. Key format is: projects/PROJECT_ID/locations/LOCATION/keyRings/KEY_RING/cryptoKeys/KEY"
  default     = null
}

variable "additional_experiments" {
  type        = list(string)
  description = "List of experiments that should be used by the job. An example value is `['enable_stackdriver_agent_metrics']`"
  default     = []
}

variable "parameters" {
  type        = map(string)
  description = "Key/Value pairs to be passed to the Dataflow job (as used in the template)."
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "User labels to be specified for the job."
  default     = {}
}
