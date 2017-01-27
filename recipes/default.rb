#
# Cookbook Name:: masala_kafka
# Recipe:: default
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

primary_if = node['network']['interfaces'][node['system']['primary_interface']]
primary_addrs = primary_if['addresses']
primary_addrs_ipv4 = primary_addrs.select { |_addr, attrs| attrs['family'] == 'inet' }
primary_ip = primary_addrs_ipv4.keys.first

node.default["kafka"]["server.properties"]["advertised.host.name"] = primary_ip

# FIXME: expose port to attrs
node.default['kafka']['zookeepers'] = node['masala_kafka']['zookeepers'].map { |z| "#{z}:2181" }

# We've used the ZK "chroot" (worst name ever) to align to cluster name. (As we can run multiple clusters against a ZK with unique cluster names)
# FIXME: we have to create the node we want to use externally, kafka will NOT autocreate
#        so this is backed out for now. New ZK recipe could allow for creating this with it's node LWRP
# node.default['kafka']['zookeeper_chroot'] = '/kafka/' + node['kafka']['cluster_name']

include_recipe 'masala_base::default'
include_recipe 'masala_exhibitor::default' if node['masala_kafka']['zk_mode'] == 'exhibitor'
include_recipe 'masala_zookeeper::default' if node['masala_kafka']['zk_mode'] == 'zookeeper'
include_recipe 'cerner_kafka::default' 
include_recipe 'masala_kafka::datadog'
include_recipe 'masala_kafka::kafkat'

