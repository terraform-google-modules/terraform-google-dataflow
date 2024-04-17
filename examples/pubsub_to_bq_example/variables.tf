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
  description = "The project ID to deploy to"
}


variable "region" {
  type        = string
  description = "The region in which the bucket will be deployed"
}

variable "service_account_email" {
  type        = string
  description = "The Service Account email used to create the job."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  default     = false
}

variable "topic_name" {
  type        = string
  description = "The Pub/Sub topic name."
}

variable "pull_subscription_name" {
  type        = string
  description = "The Pub/Sub Pull Subscription name."
}

variable "dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
}

variable "dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = null
}

variable "table" {
  description = "Table name"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Whether or not to allow deletion of tables and external tables defined by this module. Can be overriden by table-level deletion_protection configuration."
  type        = bool
  default     = false
}
