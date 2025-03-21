/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  region = var.region
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

locals {
  gcs_bucket_name = "tmp-dir-bucket-${random_id.random_suffix.hex}"
}

module "dataflow-bucket" {
  source  = "terraform-google-modules/dataflow/google//modules/dataflow_bucket"
  version = "~> 2.0"

  name       = local.gcs_bucket_name
  region     = var.region
  project_id = var.project_id
}

resource "null_resource" "download_sample_cc_into_gcs" {
  provisioner "local-exec" {
    command = <<EOF
    curl http://eforexcel.com/wp/wp-content/uploads/2017/07/1500000%20CC%20Records.zip > cc_records.zip
    unzip cc_records.zip
    rm cc_records.zip
    mv 1500000\ CC\ Records.csv cc_records.csv
    gsutil cp cc_records.csv gs://${module.dataflow-bucket.name}
    rm cc_records.csv
EOF

  }
}

resource "null_resource" "deinspection_template_setup" {
  provisioner "local-exec" {
    command = <<EOF
    if [ -f wrapped_key.txt ] && [ ${length(null_resource.create_kms_wrapped_key)}=1 ]; then
      wrapped_key=$(cat wrapped_key.txt)
    else
      wrapped_key=${var.wrapped_key}
    fi

    echo $wrapped_key

    curl https://dlp.googleapis.com/v2/projects/${var.project_id}/deidentifyTemplates -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
    -H "Content-Type: application/json" \
    -d '{"deidentifyTemplate": {"deidentifyConfig": {"recordTransformations": {"fieldTransformations": [{"fields": [{"name": "Card Number"}, {"name": "Card PIN"}], "primitiveTransformation": {"cryptoReplaceFfxFpeConfig": {"cryptoKey": {"kmsWrapped": {"cryptoKeyName": "projects/${var.project_id}/locations/global/keyRings/${var.key_ring}/cryptoKeys/${var.kms_key_name}", "wrappedKey": "'$wrapped_key'"}}, "commonAlphabet": "ALPHA_NUMERIC"}}}]}}}, "templateId": "15"}'
EOF

  }
}

resource "google_bigquery_dataset" "default" {
  project                     = var.project_id
  dataset_id                  = "dlp_demo"
  friendly_name               = "dlp_demo"
  description                 = "This is the BQ dataset for running the dlp demo"
  location                    = "US"
  default_table_expiration_ms = 3600000
}

resource "google_kms_key_ring" "create_kms_ring" {
  project  = var.project_id
  count    = var.create_key_ring ? 1 : 0
  name     = var.key_ring
  location = "global"
}

resource "google_kms_crypto_key" "create_kms_key" {
  count      = var.create_key_ring ? 1 : 0
  name       = var.kms_key_name
  key_ring   = google_kms_key_ring.create_kms_ring[0].id
  depends_on = [google_kms_key_ring.create_kms_ring]
}

resource "null_resource" "create_kms_wrapped_key" {
  count      = var.create_key_ring ? 1 : 0
  depends_on = [google_kms_crypto_key.create_kms_key]

  provisioner "local-exec" {
    command = <<EOF
  rm original_key.txt
  rm wrapped_key.txt
  python -c "import os,base64; key=os.urandom(32); encoded_key = base64.b64encode(key).decode('utf-8'); print(encoded_key)" >> original_key.txt
  original_key="$(cat original_key.txt)"
  gcloud kms keys add-iam-policy-binding ${var.kms_key_name} --project ${var.project_id} --location global --keyring ${var.key_ring} --member serviceAccount:${var.terraform_service_account_email} --role roles/cloudkms.cryptoKeyEncrypterDecrypter
  curl -s -X POST "https://cloudkms.googleapis.com/v1/projects/${var.project_id}/locations/global/keyRings/${var.key_ring}/cryptoKeys/${var.kms_key_name}:encrypt"  -d '{"plaintext":"'$original_key'"}'  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"  -H "Content-Type:application/json" | python -c "import sys, json; print(json.load(sys.stdin)['ciphertext'])" >> wrapped_key.txt
EOF

  }
}

module "dataflow-job" {
  source  = "terraform-google-modules/dataflow/google//modules/legacy"
  version = "~> 2.0"

  project_id            = var.project_id
  name                  = "dlp_example_${null_resource.download_sample_cc_into_gcs.id}_${null_resource.deinspection_template_setup.id}"
  on_delete             = "cancel"
  region                = var.region
  template_gcs_path     = "gs://dataflow-templates/latest/Stream_DLP_GCS_Text_to_BigQuery"
  temp_gcs_location     = module.dataflow-bucket.name
  service_account_email = var.service_account_email
  max_workers           = 5

  parameters = {
    inputFilePattern       = "gs://${module.dataflow-bucket.name}/cc_records.csv"
    datasetName            = google_bigquery_dataset.default.dataset_id
    batchSize              = 1000
    dlpProjectId           = var.project_id
    deidentifyTemplateName = "projects/${var.project_id}/deidentifyTemplates/15"
  }

  labels = {
    example_name = "dlp_api_example"
  }
}

resource "null_resource" "destroy_deidentify_template" {
  triggers = {
    project_id = var.project_id
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
  curl -s -X DELETE "https://dlp.googleapis.com/v2/projects/${self.triggers.project_id}/deidentifyTemplates/15" -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"
EOF
  }
}
