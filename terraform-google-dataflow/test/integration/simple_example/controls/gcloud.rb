# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
#state = attribute('state')
name = attribute('job_name')
region = attribute('region')
dataflow_job_state = attribute('dataflow_job_state')

control "gcloud" do
  title "gcloud configuration"
  #describe command("gcloud --project=#{project_id} services list --available --format=json") do
  describe command("gcloud --project=#{project_id} dataflow jobs list --format=json") do
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
      describe "contains a job with same name and location" do
        it "includes newly created dataflow job's name and location" do
          expect(data).to include(
            including(
              "name" => "#{name}",
              "location" => "#{region}",
              #"state" => "#{dataflow_job_state}",
            ),
          )
        end
      end
    end

    context "google_dataflow_job's state attribute" do
      it "is equal to JOB_STATE_RUNNING" do
        expect(dataflow_job_state).to eql ('JOB_STATE_RUNNING')
      end
    end

    #describe "enabled services" do
     # it "includes storage-api" do
      #  expect(data).to include(
       #   including(
        #    "config" =>
         #   "name" => "storage-api.googleapis.com",
          #),
        #)
      #end
    #end
  end
end
