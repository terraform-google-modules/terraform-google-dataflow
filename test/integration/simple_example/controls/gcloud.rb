# Copyright 2019 Google LLC
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
df_job_state_2 = attribute('df_job_state_2')
df_job_id_2 = attribute('df_job_id_2')
bucket_name = attribute('bucket_name')

control "gcloud" do
  title "jobs ids match"
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
            including(
              "id" => "#{df_job_id_2}"
            )
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

    context "google_dataflow_job 2 state attribute" do
      it "should be a stable state (e.g JOB_STATE_RUNNING or JOB_STATE_PENDING)" do
       expect(df_job_state_2).to match(/(JOB_STATE_RUNNING|JOB_STATE_PENDING)/)
      end
    end

  end
end

control "gsutil" do
  title "bucket configuration"
  describe command("gsutil -o Credentials:gs_service_key_file=$GOOGLE_APPLICATION_CREDENTIALS lifecycle get gs://#{bucket_name} --project=#{project_id}") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }
      its('stdout') { should match("has no lifecycle configuration.") }
  end
end
