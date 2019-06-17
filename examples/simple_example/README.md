# Simple Example

This example illustrates how to use the Dataflow module to start multiple jobs with a common bucket for temporary job data.
A network and subnetwork are created as well to demonstrate how Dataflow instance can be created in a specific network and subnetwork.


## Best practices

### Cost and Performance
As featured in this example, using a single regional bucket for storing your jobs' temporary data is recommended to optimize cost.
Also, to optimize your jobs performance, this bucket should always in the corresponding region of the zones in which your jobs are running.

## Running the example
Make sure you grant the addtional permissions below to the service account execute the module:

- roles/compute.networkAdmin


### Controller Service Account
This example features the use of a controller service accoun which is specified with the `service_account_email` input variables.
We recommend using a custome service account with fine-grained access control to mitigate security risks. See more about controller service accounts [here](https://cloud.google.com/dataflow/docs/concepts/security-and-permissions#controller_service_account)


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| force\_destroy | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | string | `"false"` | no |
| project\_id | The project ID to deploy to | string | n/a | yes |
| region | The region in which the bucket and the dataflow job will be deployed | string | n/a | yes |
| service\_account\_email | The Service Account email used to create the job. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The name of the bucket |
| df\_job\_id | The unique Id of the newly created Dataflow job |
| df\_job\_id\_2 | The unique Id of the newly created Dataflow job |
| df\_job\_name | The name of the newly created Dataflow job |
| df\_job\_name\_2 | The name of the newly created Dataflow job |
| df\_job\_state | The state of the newly created Dataflow job |
| df\_job\_state\_2 | The state of the newly created Dataflow job |
| project\_id | The project's ID |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
