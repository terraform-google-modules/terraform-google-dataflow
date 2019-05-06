# DLP API Example

This dataflow example runs the DLP Dataflow template under gs://dataflow-templates/latest/Stream_DLP_GCS_Text_to_BigQuery. It downloads a fake credit card [zipfile](http://eforexcel.com/wp/wp-content/uploads/2017/07/1500000%20CC%20Records.zip) unzips to a csv, deidentifies the credit card number and pin columns using the DLP API and dumps the data into a BigQuery dataset. 

This terraform script allows users to use their own pre-created KMS key ring/key/wrapped key by setting the variable `create_key_ring=false` or can also create all such resources for them by setting the variable `create_key_ring=true`. 


## Best practices

### Cost and Performance
As featured in this example, using a single regional bucket for storing your jobs' temporary data is recommended to optimize cost.
Also, to optimize your jobs performance, this bucket should always in the corresponding region of the zones in which your jobs are running.

### Controller Service Account
This example features the use of a controller service account which is specified with the `service_account_email` input variables.
We recommend using a custome service account with fine-grained access control to mitigate security risks. See more about controller service accounts [here](https://cloud.google.com/dataflow/docs/concepts/security-and-permissions#controller_service_account)

### GCloud
This example uses gcloud shell commands to create a wrapped key. Please ensure that you have gcloud [installed](https://cloud.google.com/sdk/install) are authenticated using `gcloud init` and also properly set the project `gcloud config set project my-project`


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
- `terraform destroy` to destroy the built infrastructure
