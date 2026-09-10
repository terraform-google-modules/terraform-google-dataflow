# Confidential Compute Example for Dataflow

This example illustrates how to configure and deploy a Google Cloud Dataflow job with [Confidential Compute](https://docs.cloud.google.com/confidential-computing/docs/confidential-computing-overview) enabled. It demonstrates how to leverage confidential VMs for Dataflow workers to protect data in use, utilizing a secure network and subnetwork configuration, and a common bucket for temporary job data. This setup ensures that your Dataflow pipelines process sensitive data in a highly protected environment, where data remains encrypted in memory and during computation within a hardware-backed trusted execution environment.

## Best practices

### Cost and Performance

As featured in this example, using a single regional bucket for storing your jobs' temporary data is recommended to optimize cost.
Also, to optimize your job's performance, this bucket should always be in the corresponding region of the zones in which your jobs are running.

### Security with Confidential Compute

Confidential Compute in Dataflow provides enhanced data protection by ensuring that data processed by worker VMs remains encrypted in memory and during computation within a hardware-backed trusted execution environment.

- **Data in Use Protection:** Data is encrypted while in use by the Dataflow workers, significantly reducing the risk of unauthorized access to sensitive information.
- **Machine Types:** This example utilizes a machine type like `n2d-standard-2`, which supports Confidential Compute. Confidential VMs typically leverage specific machine types (e.g., N2D, C2D). Ensure your chosen region supports these machine types. For a comprehensive list of supported configurations, refer to the [Confidential VM documentation](https://cloud.google.com/confidential-computing/confidential-vm/docs/supported-configurations).
- **Networking:** For maximum security, it's recommended to run Dataflow jobs with Confidential Compute on a private network (`private_ip_google_access` enabled on the subnetwork) and consider using VPC Service Controls if handling highly sensitive data to create a security perimeter.

For more details on enabling Confidential Compute and other Dataflow service options, refer to the official [Dataflow Service Options documentation](https://cloud.google.com/dataflow/docs/reference/service-options).

## Running the example

Make sure you grant the additional permissions below to the service account executing the module and to the Dataflow worker service account:

### Required IAM Roles

*   `roles/compute.networkAdmin` (for network/subnetwork creation, if applicable)
*   `roles/dataflow.admin` (for submitting Dataflow jobs)
*   `roles/dataflow.worker` (for the Dataflow worker service account)
*   `roles/compute.viewer` (for the Dataflow worker service account to view network resources)
*   `roles/storage.objectAdmin` (for the Dataflow worker service account to access temporary GCS bucket)

### Required APIs

Ensure the following APIs are enabled in your Google Cloud project:

- `compute.googleapis.com`
- `dataflow.googleapis.com`

### Controller Service Account

This example features the use of a controller service account which is specified with the `service_account_email` input variable.
We recommend using a custom service account with fine-grained access control to mitigate security risks. See more about controller service accounts [here](https://cloud.google.com/dataflow/docs/concepts/security-and-permissions#controller_service_account)

To provision this example, run the following from within this directory:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| force\_destroy | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | `bool` | `false` | no |
| project\_id | The project ID to deploy to. | `string` | n/a | yes |
| region | The region in which the bucket will be deployed. | `string` | n/a | yes |
| service\_account\_email | The Service Account email used to create the job. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The name of the bucket. |
| df\_job\_id | The unique Id of the newly created Dataflow job. |
| df\_job\_name | The name of the newly created Dataflow job. |
| df\_job\_state | The state of the newly created Dataflow job. |
| project\_id | The project's ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
