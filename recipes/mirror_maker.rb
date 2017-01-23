#
# Cookbook Name:: masala_kafka
# Recipe:: mirror_maker
#
# Copyright 2016, Paytm Labs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'masala_base::default'
include_recipe 'cerner_kafka::mirror_maker'

# register process monitor
if node['masala_base']['dd_enable'] && !node['masala_base']['dd_api_key'].nil?
  ruby_block "datadog-process-monitor-kafka-mirrormaker" do
    block do
      node.set['masala_base']['dd_proc_mon']['kafka-mirrormaker'] = {
        search_string: ['kafka.tools.MirrorMaker'],
        exact_match: false,
        thresholds: {
         critical: [1, 1]
        }
      }
    end
    notifies :run, 'ruby_block[datadog-process-monitors-render]'
  end
end

