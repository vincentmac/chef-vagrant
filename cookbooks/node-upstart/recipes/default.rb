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
  command "npm install -g n@#{node['node-upstart']['n']['version']}"
  not_if {`n -V`.chomp == "#{node['node-upstart']['n']['version']}" }
end

# Create /etc/node directory
directory node['node-upstart']['node_dir'] do
  owner "root"
  group "root"
  mode 00755
  action :create
  not_if do FileTest.directory?(node['node-upstart']['node_dir']) end
end

# Install node upstart script
template "/etc/init/node.conf" do
  path "/etc/init/node.conf"
  source "node.conf.erb"
  owner "root"
  group "root"
  mode 00644
end