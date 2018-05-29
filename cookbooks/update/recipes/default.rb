#
# Cookbook:: update
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


yum_package 'python' do
	action :upgrade
end
