# Simple Example

This example illustrates how to use the `dataflow-module` module.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The project_id to deploy the example instance into.  (e.g. "simple-sample-project-1234") | string | n/a | yes |
| region | The region to deploy to | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| df\_job\_id |  |
| df\_job\_state |  |
| job\_name | The dataflow job's name |
| project\_id | The project id used when managing resources. |
| region | The region used when managing resources. |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
