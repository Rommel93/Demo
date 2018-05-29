#
# Cookbook:: update
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


yum_package 'java' do
	action :upgrade
end
