# Terraform Google Dataflow Bucket Submodule

This submodule helps for the creation and deployment of the GCS bucket used to store temporary job data.

## Constants
The bucket is forced to be regional to optimize cost.
It is also not using `lifecycle_rule` or `force_destroy` options to prevent destroying temporary data while a job is running.


## Usage
You may use this bucket for a single job or for multiple jobs.
If deploying multiple jobs in a single region, the best practice is to use a single bucket for temporary job data.
Applying this best practice will optimize your jobs' performance.
See [here](../example/simple_example) for a multi jobs example.


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| force\_destroy | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | string | `"false"` | no |
| name | The name of the bucket. | string | n/a | yes |
| project\_id | The project_id to deploy the example instance into.  (e.g. "simple-sample-project-1234") | string | n/a | yes |
| region | The GCS bucket region. This should be the same as your dataflow job's zone ot optimize performance. | string | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | The name of the bucket |
| region | The bucket's region location |

[^]: (autogen_docs_end)


## Tests

The integration test [here](../test/integration/simple_example/controls/gcloud.rb) checks if the lifecycle rule is not enabled.
This test also implicitly checks whether or not the bucket was successfully created.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| force\_destroy | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | `bool` | `false` | no |
| name | The name of the bucket. | `string` | n/a | yes |
| project\_id | The project\_id to deploy the example instance into.  (e.g. "simple-sample-project-1234") | `string` | n/a | yes |
| region | The GCS bucket region. This should be the same as your dataflow job's zone ot optimize performance. | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | The name of the bucket |
| region | The bucket's region location |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
