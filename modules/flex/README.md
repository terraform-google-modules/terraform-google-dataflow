# [Google Dataflow Terraform Module](https://registry.terraform.io/modules/terraform-google-modules/dataflow/google)

This module handles opiniated Dataflow job configuration and deployments.

The resources/services/activations/deletions that this module will create/trigger are:
- Create a  GCS bucket for temporary job data
- Create a Dataflow job

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.
 If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v1.0.0](https://registry.terraform.io/modules/terraform-google-modules/-dataflow/google/v1.0.0).

## Usage

Before using this module, one should get familiar with the `google_dataflow_job`’s [Notes on “destroy”/”apply”](https://www.terraform.io/docs/providers/google/r/dataflow_job.html#note-on-quot-destroy-quot-quot-apply-quot-) as the behavior is atypical when compared to other resources.

### Assumption
The module is made to be used with the template_gcs_path as the staging location.
Hence, one assumption is that, before using this module, you already have working Dataflow job template(s) in GCS staging location(s).

There are examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "dataflow-job" {
  source  = "terraform-google-modules/dataflow/google"
  version = "0.1.0"

  project_id  = "<project_id>"
  name = "<job_name>"
  on_delete = "cancel"
  zone = "us-central1-a"
  max_workers = 1
  template_gcs_path =  "gs://<path-to-template>"
  temp_gcs_location = "gs://<gcs_path_temp_data_bucket"
  parameters = {
        bar = "example string"
        foo = 123
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
| autoscaling\_algorithm | The algorithm to use for autoscaling. | `string` | `null` | no |
| container\_spec\_gcs\_path | The GCS path to the Dataflow job Flex Template. | `string` | n/a | yes |
| enable\_streaming\_engine | Enable/disable the use of Streaming Engine for the job. | `bool` | `false` | no |
| kms\_key\_name | The name for the Cloud KMS key for the job. Key format is: projects/PROJECT\_ID/locations/LOCATION/keyRings/KEY\_RING/cryptoKeys/KEY | `string` | `null` | no |
| labels | User labels to be specified for the job. | `map(string)` | `{}` | no |
| launcher\_machine\_type | The machine type to use for launching the job. | `string` | `""` | no |
| machine\_type | The machine type to use for the job. | `string` | `""` | no |
| max\_workers | The number of workers permitted to work on the job. More workers may improve processing speed at additional cost. | `number` | `1` | no |
| name | The name of the dataflow job | `string` | n/a | yes |
| network\_name | The network to which VMs will be assigned. | `string` | `"default"` | no |
| on\_delete | One of drain or cancel. Specifies behavior of deletion during terraform destroy. The default is cancel. | `string` | `"cancel"` | no |
| parameters | Key/Value pairs to be passed to the Dataflow job (as used in the template). | `map(string)` | `{}` | no |
| project\_id | The project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| region | The region in which the created job should run. Also determines the location of the staging bucket if created. | `string` | `"us-central1"` | no |
| sdk\_container\_image | Docker registry location of container image to use for the 'worker harness. Default is the container for the version of the SDK. Note this field is only valid for portable pipelines. | `string` | `null` | no |
| service\_account\_email | The Service Account email that will be used to identify the VMs in which the jobs are running | `string` | `""` | no |
| skip\_wait\_on\_job\_termination | If set to true, terraform will treat DRAINING and CANCELLING as terminal states when deleting the resource, and will remove the resource from terraform state and move on. | `bool` | `false` | no |
| subnetwork | The subnetwork to which VMs will be assigned. If provided, it should be of the form of 'regions/REGION/subnetworks/SUBNETWORK'. | `string` | `""` | no |
| temp\_location | The Cloud Storage path to use for temporary files. Must be a valid Cloud Storage URL, beginning with gs://. | `string` | `null` | no |
| use\_public\_ips | Specifies whether Dataflow workers use external IP addresses. If the value is set to false, Dataflow workers use internal IP addresses for all communication. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| container\_spec\_gcs\_path | The GCS path to the Dataflow job Flex Template. |
| id | The unique Id of the newly created Dataflow job |
| name | The name of the dataflow job |
| state | The state of the newly created Dataflow job |
| temp\_location | The Cloud Storage path to use for temporary files. Must be a valid Cloud Storage URL, beginning with gs://. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform is [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The necessary APIs are [active](#enable-apis) on the project.
4. A working Dataflow template in uploaded in a GCS bucket

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active.

### Software Dependencies
### Terraform
- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v2.18.0

### Configure a Service Account to execute the module

In order to execute this module you must have a Service Account with the
following project roles:

- roles/dataflow.admin
- roles/iam.serviceAccountUser
- roles/storage.admin

### Configure a Controller Service Account to create the job

If you want to use the service_account_email input to specify a service account that will identify the VMs in which the jobs are running, the service account will need the following project roles:

- roles/dataflow.worker
- roles/storage.objectAdmin

### Configure a Customer Managed Encryption Key

If you want to use [Customer Managed Encryption Keys](https://cloud.google.com/kms/docs/cmek) in the [Dataflow Job](https://cloud.google.com/dataflow/docs/guides/customer-managed-encryption-keys) use the variable `kms_key_name` to provide a valid key.
Follow the instructions in [Granting Encrypter/Decrypter permissions](https://cloud.google.com/dataflow/docs/guides/customer-managed-encryption-keys#granting_encrypterdecrypter_permissions) to configure the necessary roles for the Dataflow service accounts.

### Enable APIs

In order to launch a Dataflow Job, the Dataflow API must be enabled:

- Dataflow API - `dataflow.googleapis.com`
- Compute Engine API: `compute.googleapis.com`

**Note:** If you want to use a Customer Managed Encryption Key, the Cloud Key Management Service (KMS) API must be enabled:

- Cloud Key Management Service (KMS) API: `cloudkms.googleapis.com`

## Install

### Terraform
Be sure you have the correct Terraform version (0.12.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [gcloud](https://cloud.google.com/sdk/install)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.6.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test

Integration tests are run though [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).

`test-kitchen` instances are defined in [`.kitchen.yml`](./.kitchen.yml). The test-kitchen instances in `test/fixtures/` wrap identically-named examples in the `examples/` directory.

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and put it in the module's root directory with the name `credentials.json`.
3. Build the Docker container for testing:

  ```
  make docker_build_kitchen_terraform
  ```
4. Run the testing container in interactive mode:

  ```
  make docker_run
  ```

  The module root directory will be loaded into the Docker container at `/cft/workdir/`.
5. Run kitchen-terraform to test the infrastructure:

  1. `kitchen create` creates Terraform state and downloads modules, if applicable.
  2. `kitchen converge` creates the underlying resources. Run `kitchen converge <INSTANCE_NAME>` to create resources for a specific test case.
  3. `kitchen verify` tests the created infrastructure. Run `kitchen verify <INSTANCE_NAME>` to run a specific test case.
  4. `kitchen destroy` tears down the underlying resources created by `kitchen converge`. Run `kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

Alternatively, you can simply run `make test_integration_docker` to run all the test steps non-interactively.

#### Test configuration

Each test-kitchen instance is configured with a `variables.tfvars` file in the test fixture directory. For convenience, since all of the variables are project-specific, these files have been symlinked to `test/fixtures/shared/terraform.tfvars`.
Similarly, each test fixture has a `variables.tf` to define these variables, and an `outputs.tf` to facilitate providing necessary information for `inspec` to locate and query against created resources.

Each test-kitchen instance creates necessary fixtures to house resources.

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform, or Dockerfiles. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform validate
Running hadolint on Dockerfiles
Checking for required files
Testing the validity of the header check
..
----------------------------------------------------------------------
Ran 2 tests in 0.026s

OK
Checking file headers
The following lines have trailing whitespace
```

The linters
are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang
is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform validate'
command.
* Dockerfiles - hadolint. Can be found in homebrew
