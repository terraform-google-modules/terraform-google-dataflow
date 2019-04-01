variable "project_id" {
  description = "The project_id to deploy the example instance into.  (e.g. \"simple-sample-project-1234\")"
}

variable "bucket_region" {
    description = "The GCS bucket region. This should be the same as your dataflow job's zone ot optimize performance."
    default = "us-central1"
}

variable "bucket_name" {
    description = "(Required) The name of the bucket."
}