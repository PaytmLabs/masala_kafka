#
# Cookbook Name:: masala_kafka
# Recipe:: kafkat
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

ruby_runtime 'ruby' do
  version '2.3'
  provider :ruby_build
end
ruby_gem 'kafkat'

template "/etc/kafkatcfg" do
  source  "kafkatcfg.erb"
  owner 'root'
  group node['root_group']
  mode  00755
end

link "/usr/local/bin/kafkat" do
  to "/opt/ruby_build/builds/ruby/bin/kafkat"
end


