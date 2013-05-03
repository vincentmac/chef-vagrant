#
# Cookbook Name:: node-upstart
# Recipe:: default
#
# Copyright 2013, Simplicity.io
#
# All rights reserved - Do Not Redistribute
#
# http://clock.co.uk/tech-blogs/upstart-and-nodejs

# Install n to allow for different versions of node.js
execute "npm install -g n" do
  command "sudo npm install -g n@#{node['node-upstart']['n']['version']}"
  not_if {FileTest.file?("/usr/local/bin/n") || `sudo n -V`.chomp == "#{node['node-upstart']['n']['version']}" }
end

# Install curl (needed by n)
package 'curl' do
  action :install
end

# Install vim
package 'vim' do
  action :install
end

# Create /var/www directory if it does not exist
directory "/var/www" do
  owner "root"
  group "root"
  mode 00755
  action :create
  not_if do FileTest.directory?("/var/www") end
end

# Create /var/log/node directory if it does not exist
directory node['node-upstart']['node_log_dir'] do
  owner "root"
  group "root"
  mode 00755
  action :create
  not_if do FileTest.directory?(node['node-upstart']['node_log_dir']) end
end

# Create /etc/node directory
# directory node['node-upstart']['node_dir'] do
#   owner "root"
#   group "root"
#   mode 00755
#   action :create
#   not_if do FileTest.directory?(node['node-upstart']['node_dir']) end
# end

# Install node upstart script
# template "/etc/init/node.conf" do
#   path "/etc/init/node.conf"
#   source "node.conf.erb"
#   owner "root"
#   group "root"
#   mode 00644
# end

# service "node" do
#   service_name "node"
#   if node['node-upstart']['use_upstart']
#     provider Chef::Provider::Service::Upstart
#   end
#   supports :start => true, :stop => true, :status => true, :restart => true, :reload => true
#   # action :enable
# end

# Install nodeSites upstart script
# template "/etc/init/nodeSites.conf" do
#   path "/etc/init/nodeSites.conf"
#   source "nodeSites.conf.erb"
#   owner "root"
#   group "root"
#   mode 00644
# end

# service "nodeSites" do
#   service_name "nodeSites"
#   if node['node-upstart']['use_upstart']
#     provider Chef::Provider::Service::Upstart
#   end
#   supports :start => true, :stop => true, :status => true, :restart => true, :reload => true
#   action :disable
# end

# service "nodeSites" do
#   # action [:enable, :start]
#   action :start
# end