# Simple Example

This example illustrates how to use the `dataflow-module` module.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The project_id to deploy the example instance into.  (e.g. "simple-sample-project-1234") | string | n/a | yes |
| region | The region to deploy to | string | n/a | yes |
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
| project\_id | The project id used when managing resources. |
| region | The region used when managing resources. |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
