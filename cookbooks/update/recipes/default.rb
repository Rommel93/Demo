#
# Cookbook:: update
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


yum_package 'httpd' do
	action :upgrade
end
