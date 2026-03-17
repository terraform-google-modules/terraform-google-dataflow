# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
region = attribute('region')
df_job_state = attribute('df_job_state')
df_job_id = attribute('df_job_id')
bucket_name = attribute('bucket_name')

control "gcloud" do
  title "Dataflow jobs IDs match"
  describe command("gcloud --project=#{project_id} dataflow jobs list --format=json --region=#{region}") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    context "gcloud dataflow jobs list OUTPUT" do
      describe "contains all successful and failed jobs for the target project" do
        it "should include the newly created dataflow jobs' job_ids" do
          expect(data).to include(
            including(
              "id" => "#{df_job_id}"
            ),
          )
        end
      end
    end
  end
end

control "gcloud_dataflow" do
  title "jobs state"
  describe command("gcloud --project=#{project_id} dataflow jobs list --format=json --region=#{region}") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }


    context "google_dataflow_job 1 state attribute" do
      it "should be a stable state (e.g JOB_STATE_RUNNING or JOB_STATE_PENDING)" do
       expect(df_job_state).to match(/(JOB_STATE_RUNNING|JOB_STATE_PENDING)/)
      end
    end
  end
end

control "dataflow_confidential_compute_enabled" do
  title "Dataflow job should have Confidential Compute enabled"
  describe command("gcloud --project=#{project_id} dataflow jobs describe #{df_job_id} --region=#{region} --format=json --full") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:job_details) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "should have 'enable_confidential_compute' in its environment experiments" do
      expect(job_details['environment']['experiments']).to include('enable_confidential_compute')
    end
  end
end
