variable "project_id" {
  description = "The project_id to deploy the example instance into.  (e.g. \"simple-sample-project-1234\")"
}

variable "region" {
  description = "The region to deploy to"
  default     = "us-east1"
}

variable "zone" {
  description = "The zone to deploy to"
  default     = "us-central1-a"
}

variable "service_account_email" {
  description = "The Service Account email used to create the job."
}
