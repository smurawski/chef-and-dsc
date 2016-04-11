#
# Cookbook Name:: chef-and-dsc
# Recipe:: default
#
# Copyright (c) 2016 Chef Software, All Rights Reserved.

# Use PowerShellGet to grab a version of xWebAdministration
powershell_script 'xWebAdministration' do
  code <<-EOH
    install-packageprovider nuget -force -forcebootstrap
    install-module xWebAdministration -force -requiredversion 1.10.0.0
  EOH
  not_if '(Get-Module xWebAdministration -list) -ne $null'
end

local_configuration_manager 'Setup defaults'
