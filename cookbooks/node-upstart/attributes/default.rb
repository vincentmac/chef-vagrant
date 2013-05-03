#
# Author:: Vincent Mac (<vincent@simplicity.io>)
# Cookbook Name:: node-upstart
# Attributes:: default
#
# Copyright 2013, Simplicity.io
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
#

default['node-upstart']['n']['version'] = "0.9.3"
default['node-upstart']['node_dir'] = "/etc/node"
default['node-upstart']['node_bin'] = "/usr/local/bin/n"
default['node-upstart']['node_log_dir'] = "/var/log/node"
default['node-upstart']['use_upstart'] = true
default['node-upstart']['repos_dir'] = "/home/ubuntu/repos"
default['node-upstart']['repo_user'] = "ubuntu"

# Simplicity.io Nginx Config
default['node-upstart']['simplicity']['site'] = "simplicity.io"
default['node-upstart']['simplicity']['port'] = 3000
default['node-upstart']['simplicity']['aws_signin'] = "simplicity-aws"
default['node-upstart']['simplicity']['enabled'] = true

# Simplicity.io Git Repo Settings
default['node-upstart']['simplicity']['remote_repo'] = "/home/ubuntu/repos/simplicity.io"
default['node-upstart']['simplicity']['remote_hooks'] = "/home/ubuntu/repos/simplicity.io/hooks"
default['node-upstart']['simplicity']['private_repo'] = "git@bitbucket.org:vincentmac/simplicity.io.git"


# Simplicity.io Application Settings
default['node-upstart']['simplicity']['app_dir'] = "/var/www/simplicity.io"
default['node-upstart']['simplicity']['app_bin'] = "/var/www/simplicity.io/current/app.js"
default['node-upstart']['simplicity']['log_dir'] = "/var/log/node/simplicity.io"
default['node-upstart']['simplicity']['log_path'] = "/var/log/node/simplicity.io/simplicity.io.log"
default['node-upstart']['simplicity']['node_version'] = "0.10.3"
default['node-upstart']['simplicity']['node_env'] = "production"
default['node-upstart']['simplicity']['filename'] = "simplicity"
default['node-upstart']['simplicity']['service_name'] = "simplicity"
