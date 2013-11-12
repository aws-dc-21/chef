#
# Cookbook Name:: donorschoose
# Recipe:: postgres
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::client'
include_recipe 'postgresql::server'
include_recipe 'postgresql::initdb'