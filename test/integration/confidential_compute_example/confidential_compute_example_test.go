// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package confidentialcompute_example_test

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestConfidentialCompute(t *testing.T) {
	test := tft.NewTFBlueprintTest(
		t,
	)

	test.DefineVerify(func(assert *assert.Assertions) {
		test.DefaultVerify(assert)

		projectId := test.GetStringOutput("project_id")
		region := test.GetStringOutput("region")
		jobId := test.GetStringOutput("df_job_id")
		jobState := test.GetStringOutput("df_job_state")

		jobs := gcloud.Run(t, fmt.Sprintf("dataflow jobs list --project=%s --region=%s", projectId, region)).Array()
		foundJob := false
		for _, j := range jobs {
			if j.Get("id").String() == jobId {
				foundJob = true
				break
			}
		}
		assert.True(foundJob, fmt.Sprintf("Dataflow must create a job with id %s", jobId))

		isStable := jobState == "JOB_STATE_RUNNING" || jobState == "JOB_STATE_PENDING"
		assert.True(isStable, fmt.Sprintf("The current job state is '%s', it must be JOB_STATE_RUNNING or JOB_STATE_PENDING", jobState))

		jobDesc := gcloud.Run(t, fmt.Sprintf("dataflow jobs describe %s --project=%s --region=%s --full", jobId, projectId, region))
		experiments := jobDesc.Get("environment.experiments").Array()
		hasConfidentialCompute := false
		for _, exp := range experiments {
			if exp.String() == "enable_confidential_compute" {
				hasConfidentialCompute = true
				break
			}
		}
		assert.True(hasConfidentialCompute, "A flag 'enable_confidential_compute' must be enabled")

	})

	test.Test()
}
