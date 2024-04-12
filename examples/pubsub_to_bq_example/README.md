# Dataflow Custom Template Deployment

This Terraform module sets up a data pipeline for reading logs from a Pub/Sub pull subscription and writing them to BigQuery tables using a custom Dataflow template.

## Prerequisites
Before using this module, ensure the following prerequisites are met:

- Pub/Sub Topic and Subscription: You must have an existing Pub/Sub topic and subscription. If not, you can create them using the Google Cloud Console or the gcloud command-line tool or using Pub/Sub Terraform Module.
- BigQuery Table: You must have an existing BigQuery table where you want to store the logs. If not, create a table using the BigQuery web UI or the bq command-line tool or using the BigQuery terraform module.
- **Custom Dataflow Template** : Before using this module, ensure you have created a custom Dataflow template and uploaded it to a GCS bucket. You can follow the steps outlined in the [official documentation](https://cloud.google.com/dataflow/docs/guides/templates/creating-templates) to create and deploy a custom template.


When you run your pipeline, Dataflow uses two service accounts to manage security and permissions:
1. Dataflow Service Account : Dataflow service account as part of the job creation request, such as to check project quota and to create worker instances on your behalf.
2. Dataflow Worker Service Account : Worker instances use the worker service account to access input and output resources after you submit your job.By default, workers use the `Compute Engine default service account` associated with your project as the worker service account.
- It is highly recommended to create a user-managed worker service account (that we're also passing in the dataflow module)
- The Dataflow Worker Service Account must have permission to consume logs/messages from pub/sub and write to BigQuery.
     - `roles/dataflow.admin`
     - `roles/dataflow.worker`
     - `roles/bigquery.dataEditor`
     - `roles/storage.objectViewer`
     - `roles/storage.objectCreator`
     - Dataflow is reading logs/messages from Pub/Sub : `roles/pubsub.subsciber`
     - Dataflow is writing messgaes to BigQuery : `roles/bigquery.dataEditor`

3. **Configure a Service Account to execute the module** : In order to execute this module you must have a Service Account with the following project roles:
    - `roles/dataflow.admin`
    - `roles/iam.serviceAccountUser`
    - `roles/storage.admin`

4. **Enable APIs** : In order to launch a Dataflow Job, the Dataflow API must be enabled:
    - Dataflow API - dataflow.googleapis.com
    - Compute Engine API: compute.googleapis.com
Note: If you want to use a Customer Managed Encryption Key, the Cloud Key Management Service (KMS) API must be enabled:
    - Cloud Key Management Service (KMS) API: cloudkms.googleapis.com

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
| additional\_experiments | List of experiments that should be used by the job. An example value is `['enable_stackdriver_agent_metrics']` | `list(string)` | `[]` | no |
| force\_destroy | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | `bool` | `false` | no |
| ip\_configuration | The configuration for VM IPs. Options are 'WORKER\_IP\_PUBLIC' or 'WORKER\_IP\_PRIVATE'. | `string` | `null` | no |
| kms\_key\_name | The name for the Cloud KMS key for the job. Key format is: projects/PROJECT\_ID/locations/LOCATION/keyRings/KEY\_RING/cryptoKeys/KEY | `string` | `null` | no |
| labels | User labels to be specified for the job. | `map(string)` | `{}` | no |
| machine\_type | The machine type to use for the job. | `string` | `""` | no |
| max\_workers | The number of workers permitted to work on the job. More workers may improve processing speed at additional cost. | `number` | `1` | no |
| name | The name of the dataflow job | `string` | n/a | yes |
| network\_self\_link | The network self link to which VMs will be assigned. | `string` | `"default"` | no |
| on\_delete | One of drain or cancel. Specifies behavior of deletion during terraform destroy. The default is cancel. | `string` | `"cancel"` | no |
| parameters | Key/Value pairs to be passed to the Dataflow job (as used in the template). | `map(string)` | `{}` | no |
| project\_id | ID of the project | `string` | n/a | yes |
| region | The region in which the created job should run. Also determines the location of the staging bucket if created. | `string` | `"us-central1"` | no |
| service\_account\_email | The Service Account email that will be used to identify the VMs in which the jobs are running | `string` | `""` | no |
| subnetwork\_self\_link | The subnetwork self link to which VMs will be assigned. | `string` | `""` | no |
| template\_gcs\_path | The GCS path to the Dataflow job template. | `string` | n/a | yes |
| zone | The zone in which the created job should run. | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The name of the bucket |
| df\_job\_id | The unique Id of the newly created Dataflow job |
| df\_job\_name | The name of the newly created Dataflow job |
| df\_job\_state | The state of the newly created Dataflow job |
| project\_id | The project's ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

