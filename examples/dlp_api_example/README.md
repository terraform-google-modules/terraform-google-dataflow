# DLP API Example

This dataflow example runs the DLP Dataflow template under gs://dataflow-templates/latest/Stream_DLP_GCS_Text_to_BigQuery. It downloads a fake credit card [zipfile](http://eforexcel.com/wp/wp-content/uploads/2017/07/1500000%20CC%20Records.zip) unzips to a csv, deidentifies the credit card number and pin columns using the DLP API and dumps the data into a BigQuery dataset.

This terraform script allows users to use their own pre-created KMS key ring/key/wrapped key by setting the variable `create_key_ring=false` or can also create all such resources for them by setting the variable `create_key_ring=true`.


## Best practices

### Cost and Performance
As featured in this example, using a single regional bucket for storing your jobs' temporary data is recommended to optimize cost.
Also, to optimize your jobs performance, this bucket should always in the corresponding region of the zones in which your jobs are running.
##
Make sure the terraform service account to execute the example has the basic  permissions needed for the module listed [here](../../README#configure-a-service-account-to-execute-the-module)
Grant these additional permissions to the service account needed to run the example:
- roles/bigquery.admin
- roles/iam.serviceAccountUser
- roles/storage.admin
- roles/cloudkms.admin
- roles/dlp.admin
- roles/cloudkms.cryptoKeyEncrypterDecrypter

### Controller Service Account
This example features the use of a controller service account which is specified with the `service_account_email` input variables.
We recommend using a custom service account with fine-grained access control to mitigate security risks. See more about controller service accounts [here](https://cloud.google.com/dataflow/docs/concepts/security-and-permissions#controller_service_account)

In order to execute this module, your Controller Service Account uses the following project roles:
- roles/dataflow.worker
- roles/storage.admin
- roles/bigquery.admin
- roles/cloudkms.admin
- roles/dlp.admin
- roles/cloudkms.cryptoKeyEncrypterDecrypter

### GCloud
This example uses gcloud shell commands to create a wrapped key and download the sample cc data. Please ensure that you have gcloud [installed](https://cloud.google.com/sdk/install) are authenticated using `gcloud init` and also properly set the project `gcloud config set project my-project`. You may need to enable the following APIs- see [here](https://cloud.google.com/apis/docs/enable-disable-apis)
- Cloud Key Management Service (KMS) API: `cloudkms.googleapis.com`
- Cloud Storage API : `storage-component.googleapis.com`
- DLP API: `dlp.googleapis.com`


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The project ID to deploy to | string | n/a | yes |
| region | The region in which the bucket and the dataflow job will be deployed | string | n/a | yes |
| service\_account\_email | The Service Account email used to create the job. | string | n/a | yes |
| key\_ring | The KMS key ring used to create a wrapped key (can be existing or created) | string | n/a | yes |
| kms\_key\_name | The KMS key within the key ring used to create a wrapped key (can be existing or created) | string | n/a | yes |
| wrapped\_key | The wrapped key generated from KMS used to encrypt sensitive information (leave blank if generating from terraform) | string | "" | yes |
| create\_key\_ring | Boolean for creating own KMS key ring/key or using pre-created resource | string | "true" | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The name of the bucket |
| df\_job\_id | The unique Id of the newly created Dataflow job |
| df\_job\_name | The name of the newly created Dataflow job |
| df\_job\_state | The state of the newly created Dataflow job |
| project\_id | The project's ID |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure. (Note that KMS key rings and crypto keys cannot be destroyed!)
