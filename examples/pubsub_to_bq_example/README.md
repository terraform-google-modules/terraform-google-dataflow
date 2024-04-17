# Pub/Sub to BigQuery Dataflow Template

This Terraform module sets up a Google Cloud Pub/Sub to BigQuery dataflow template, allowing you to easily stream data from Pub/Sub topics into BigQuery tables using Dataflow.

## Prerequisites
Before using this module, ensure the following prerequisites are met:

When you run your pipeline, Dataflow uses two service accounts to manage security and permissions:
1. Dataflow Service Account : Dataflow service account as part of the job creation request, such as to check project quota and to create worker instances on your behalf.
2. Dataflow Worker Service Account : Worker instances use the worker service account to access input and output resources after you submit your job.By default, workers use the `Compute Engine default service account` associated with your project as the worker service account.
- It is highly recommended to create a user-managed worker service account (that we're also passing in the dataflow module)
- The Dataflow Worker Service Account must have permission to consume logs/messages from pub/sub and write to BigQuery.
     - `roles/dataflow.admin`
     - `roles/dataflow.worker`
     - `roles/storage.objectViewer`
     - `roles/storage.objectCreator`
     - Dataflow is reading logs/messages from Pub/Sub : `roles/pubsub.subsciber`
     - Dataflow is writing messgaes to BigQuery : `roles/bigquery.dataEditor`

3. **Configure a Service Account to execute the module** : In order to execute this module you must have a Service Account with the following project roles:
    - `roles/pubsub.editor`
    - `roles/bigquery.dataEditor`
    - `roles/dataflow.admin`
    - `roles/iam.serviceAccountUser`
    - `roles/storage.admin`

4. **Enable APIs** : In order to launch a Dataflow Job, the Dataflow API must be enabled:
    - Dataflow API : dataflow.googleapis.com
    - Compute Engine API: compute.googleapis.com
    - BigQuery API : bigquery.googleapis.com
    - Pub/Sub API : pubsub.googleapis.com
    - Storage API : storage.googleapis.com

## Usage

```hcl
module "dataflow-job" {
  source  = "terraform-google-modules/dataflow/google"
  version = "~>2.4.0"

  project_id  = "<project_id>"
  name = "<job_name>"
  on_delete = "drain"
  zone = "us-central1-a"
  max_workers = 1
  template_gcs_path =  "gs://<path-to-template>"
  temp_gcs_location = "gs://<gcs_path_temp_data_bucket"
  parameters = {
        //Pass all the custom parameters that are require to run the dataflow template
  }
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dataset\_id | Unique ID for the dataset being provisioned. | `string` | n/a | yes |
| dataset\_name | Friendly name for the dataset being provisioned. | `string` | `null` | no |
| deletion\_protection | Whether or not to allow deletion of tables and external tables defined by this module. Can be overriden by table-level deletion\_protection configuration. | `bool` | `false` | no |
| force\_destroy | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | `bool` | `false` | no |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| pull\_subscription\_name | The Pub/Sub Pull Subscription name. | `string` | n/a | yes |
| region | The region in which the bucket will be deployed | `string` | n/a | yes |
| service\_account\_email | The Service Account email used to create the job. | `string` | `null` | no |
| table | Table name | `string` | `null` | no |
| topic\_name | The Pub/Sub topic name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The name of the bucket |
| df\_job\_id | The unique Id of the newly created Dataflow job |
| df\_job\_name | The name of the newly created Dataflow job |
| df\_job\_state | The state of the newly created Dataflow job |
| project\_id | The project's ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->




