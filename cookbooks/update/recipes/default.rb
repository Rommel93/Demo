#
# Cookbook:: update
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


yum_package '#{package}' do
	action :upgrade
end
