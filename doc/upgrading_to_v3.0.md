# Upgrading to v3.0
Dataflow legacy template job module has been moved to /modules/legacy.

```diff
  module "dataflow-job" {
-   source           = "terraform-google-modules/dataflow/google"
+   source           = "terraform-google-modules/dataflow/google//modules/legacy"
...
}
```

In addition, below variables have changed:
- Added `enable_streaming_engine ` and `skip_wait_on_job_termination`
- Changed `ip_configuration` to `use_public_ips`
- Renamed `network_self_link ` to `network_name`
- Renamed `subnetwork_self_link ` to `subnetwork`
- Removed `zone`
```diff
  module "dataflow-job" {
...
-   ip_configuration        = "WORKER_IP_PUBLIC"
+   use_public_ips          = true
-   network_self_link       = "default"
+   network_name            = "default"
-   subnetwork_self_link    = "regions/us-central1/subnetworks/dataflow-pipeline"
+   subnetwork              = "regions/us-central1/subnetworks/dataflow-pipeline"
-   zone                    = "us-central1-a"
...
}
```
