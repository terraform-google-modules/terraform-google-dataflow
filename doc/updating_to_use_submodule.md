# Updating to Submodule
Dataflow legacy template job module has been moved to /modules/legacy.

```diff
  module "dataflow-job" {
-   source           = "terraform-google-modules/dataflow/google"
+   source           = "terraform-google-modules/dataflow/google//modules/legacy"
...
}
```
