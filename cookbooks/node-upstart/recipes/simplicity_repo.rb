#
# Cookbook Name:: node-upstart
# Recipe:: simplicity_repo
#
# Copyright 2013, Simplicity.io
#
# All rights reserved - Do Not Redistribute

# Create repos directory if it does not exist
directory node['node-upstart']['simplicity']['repos_dir'] do
  owner node['node-upstart']['simplicity']['repo_user']
  group node['node-upstart']['simplicity']['repo_user']
  mode 00755
  action :create
  not_if do FileTest.directory?(node['node-upstart']['simplicity']['repos_dir']) end
end

# Only create remote repo and init if it does not exist
if (! FileTest.directory?(node['node-upstart']['simplicity']['remote_repo']))

  # Create repo directory if it does not exist
  directory node['node-upstart']['simplicity']['remote_repo'] do
    owner node['node-upstart']['simplicity']['repo_user']
    group node['node-upstart']['simplicity']['repo_user']
    mode 00755
    action :create
    # not_if do FileTest.directory?(node['node-upstart']['simplicity']['remote_repo']) end
  end

  # init bare repo
  execute "init_remote_repo" do
    user node['node-upstart']['simplicity']['repo_user']
    cwd node['node-upstart']['simplicity']['remote_repo']
    command "git init --bare"
  end

end

# Copy post-receive hook to repo
template node['node-upstart']['simplicity']['remote_hooks'] do
  path "#{node['node-upstart']['simplicity']['remote_hooks']}/post-receive"
  source "post-receive.erb"
  owner node['node-upstart']['simplicity']['repo_user']
  group node['node-upstart']['simplicity']['repo_user']
  mode 00774
  variables(
    :service => node['node-upstart']['simplicity']['service_name'],
    :app_dir => node['node-upstart']['simplicity']['app_dir'],
    :remote_hook => node['node-upstart']['simplicity']['remote_hooks']
  )
  # notifies :restart, 'service[lessonsforlife]'
end