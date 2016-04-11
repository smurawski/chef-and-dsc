#
# Cookbook Name:: chef-and-dsc
# Recipe:: sample
#
# Copyright (c) 2016 Chef Software, All Rights Reserved.

include_recipe 'chef-and-dsc::default'

dsc_resource 'Install IIS' do
  resource :windowsfeature
  property :name,  'web-server'
end

service 'w3svc' do
  action [:enable, :start]
end

dsc_resource 'Shutdown Default Website' do
  resource :xWebsite
  property :name, 'Default Web Site'
  property :State, 'Stopped'
  property :PhysicalPath, 'C:\inetpub\wwwroot'
end

# Make sure we have a folder for our website
directory 'c:/sites/ChefAndDsc' do
  recursive true
end

# Drop in a basic web page
template 'c:/sites/ChefAndDsc/index.html' do
  source 'index.html'
  action :create
end

dsc_resource 'New Website' do
  resource :xWebsite
  property :name, 'ChefAndDsc'
  property :State, 'Started'
  property :BindingInfo, cim_instance_array(
    'MSFT_xWebBindingInformation',
    protocol: 'http',
    port: 8080)
  property :PhysicalPath, 'c:\sites\ChefAndDsc'
end
