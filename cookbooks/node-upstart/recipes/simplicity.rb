#
# Cookbook Name:: node-upstart
# Recipe:: simplicity
#
# Copyright 2013, Simplicity.io
#
# All rights reserved - Do Not Redistribute
#
# http://clock.co.uk/tech-blogs/upstart-and-nodejs

# Create webapp directory if it does not exist
directory node['node-upstart']['simplicity']['app_dir'] do
  owner node['node-upstart']['repo_user']
  group node['nginx']['user']
  mode 00755
  action :create
  not_if do FileTest.directory?(node['node-upstart']['simplicity']['app_dir']) end
end

# Create webapp log directory if it does not exist
directory node['node-upstart']['simplicity']['log_dir'] do
  owner node['nginx']['user']
  group "root"
  mode 00755
  action :create
  not_if do FileTest.directory?(node['node-upstart']['simplicity']['log_dir']) end
end

# Create hello world node app.js if empty dir
# cookbook_file node['node-upstart']['simplicity']['app_bin'] do
#   source "app.js"
#   owner node['node-upstart']['repo_user']
#   group node['nginx']['user']
#   mode 00755
#   not_if do FileTest.file?(node['node-upstart']['simplicity']['app_bin']) end
# end

# Install node version via n
execute "sudo n #{node['node-upstart']['simplicity']['node_version']}" do
  command "sudo n #{node['node-upstart']['simplicity']['node_version']}"
end


# Deploy app from bitbucket private repo

# Create .ssh directory
directory "#{node['node-upstart']['simplicity']['app_dir']}/.ssh" do
  owner node['node-upstart']['repo_user']
  recursive true
  action :create
  not_if do FileTest.directory?("#{node['node-upstart']['simplicity']['app_dir']}/.ssh") end
end

# Create private ssh key id_deploy from data bag
file "#{node['node-upstart']['simplicity']['app_dir']}/.ssh/id_deploy" do
  simplicity_app = data_bag_item("apps", "simplicity_app")
  content simplicity_app["deploy_key"]
  mode 00600
  user node['node-upstart']['repo_user']
end

# Create ssh wrapper
cookbook_file "#{node['node-upstart']['simplicity']['app_dir']}/simplicity-sshwrap.sh" do
  source "simplicity-sshwrap.sh"
  owner node['node-upstart']['repo_user']
  mode 00700
end

# True if simplicity.conf file does not exist 
enable_start_needed = !FileTest.file?("/etc/init/#{node['node-upstart']['simplicity']['filename']}.conf")

deploy "simplicity.io" do
  repo node['node-upstart']['simplicity']['private_repo']
  user node['node-upstart']['repo_user']
  deploy_to node['node-upstart']['simplicity']['app_dir']
  action :deploy
  ssh_wrapper "#{node['node-upstart']['simplicity']['app_dir']}/simplicity-sshwrap.sh"
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end

# Create node.js site instance template and launch application
template "/etc/init/#{node['node-upstart']['simplicity']['filename']}.conf" do
  path "/etc/init/#{node['node-upstart']['simplicity']['filename']}.conf"
  source "node-app.conf.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
    :app_name => node['node-upstart']['simplicity']['service_name'],
    :filename => node['node-upstart']['simplicity']['filename'],
    :node_version => node['node-upstart']['simplicity']['node_version'],
    :app_bin => node['node-upstart']['simplicity']['app_bin'],
    :log_path => node['node-upstart']['simplicity']['log_path'],
    :node_env => node['node-upstart']['simplicity']['node_env'],
    :port => node['node-upstart']['simplicity']['port'],
    :user => node['nginx']['user']
  )
end

# Define Service
service "simplicity" do
  # service_name "simplicity"
  if enable_start_needed
    provider Chef::Provider::Service::Upstart
    action [ :enable, :start ]
  else
    action [ :restart ]
  end
  supports :status => true, :restart => true, :reload => true, :start => true, :stop => true
  stop_command "sudo stop simplicity"
  start_command "sudo start simplicity"
  restart_command "sudo stop simplicity && sudo start simplicity"
  subscribes :reload, resources("template[/etc/init/simplicity.conf]"), :immediately
end

# Create Nginx Site
template "#{node['nginx']['dir']}/sites-available/simplicity.io" do
  source "simplicity-site.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

# Enable New Nginx Site
nginx_site 'simplicity.io' do
  enable node['node-upstart']['simplicity']['enabled']
end
