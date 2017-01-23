#
# Cookbook Name:: masala_kafka
# Recipe:: confluent_proxy
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
include_recipe 'masala_kafka::confluent_install'

template "#{node["confluent"]["install_dir"]}/etc/kafka-rest/kafka-rest.properties" do
  source  "key_equals_value.erb"
  owner node["kafka"]["user"]
  group node["kafka"]["group"]
  mode  00755
  variables(
      { :properties => node["confluent"]['proxy']['conf'].to_hash }
  )
  #notifies :restart, "service[confluent-proxy]"
end

template "#{node["confluent"]["install_dir"]}/etc/kafka-rest/log4j.properties" do
  source  "key_equals_value.erb"
  owner node["kafka"]["user"]
  group node["kafka"]["group"]
  mode  00755
  variables(
      { :properties => node["confluent"]['proxy']['log4j'].to_hash }
  )
  #notifies :restart, "service[confluent-proxy]"
end

template "/etc/init.d/confluent-proxy" do
  source "confluent_proxy_initd.erb"
  owner "root"
  group "root"
  mode  00755
  notifies :restart, "service[confluent-proxy]"
end

# Start/Enable Kafka
service "confluent-proxy" do
  action [:enable, :start]
end

if node['masala_base']['dd_enable'] and not node['masala_base']['dd_api_key'].nil?
  node.set['datadog']['confluent-proxy']['instances'] = [
      {
          host: 'localhost',
          port: node['confluent']['proxy']['env']['JMX_PORT']
          #name: node['kafka']['cluster_name']
      }
  ]
  datadog_monitor 'confluent-proxy' do
    instances node['datadog']['confluent-proxy']['instances']
    cookbook 'masala_kafka'
  end

  # port monitoring, should merge with others on host
  node.set['datadog']['http_check']['instances'] ||= []
  node.set['datadog']['http_check']['instances'] = node['datadog']['http_check']['instances'].to_a.push( {
    :name => 'confluent-proxy-port',
    :url  => 'http://localhost:8082/topics',
    :timeout => 1,
    :collect_response_time => true
  })
  datadog_monitor 'http_check' do
    instances node['datadog']['http_check']['instances']
  end

end

# register process monitor
if node['masala_base']['dd_enable'] && !node['masala_base']['dd_api_key'].nil?
  ruby_block "datadog-process-monitor-confluent-proxy" do
    block do
      node.set['masala_base']['dd_proc_mon']['confluent-proxy'] = {
        search_string: ['io.confluent.kafkarest.KafkaRestMain'],
        exact_match: false,
        thresholds: {
         critical: [1, 1]
        }
      }
    end
    notifies :run, 'ruby_block[datadog-process-monitors-render]'
  end
end

