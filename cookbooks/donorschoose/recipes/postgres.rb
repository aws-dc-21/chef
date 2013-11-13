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
include_recipe 'postgresql::ruby'
include_recipe 'postgresql::config_initdb'

package 'gzip'

postgresql_connection_info = {
    :host     => 'localhost',
    :port     => node['postgresql']['config']['port'],
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres']
}

postgresql_database 'donorschoose' do
  connection postgresql_connection_info
  action :create
end

node['postgres']['users'].each do |user, opts|
  postgresql_database_user user do
    connection    postgresql_connection_info
    password      opts[:password]
    action        :create
  end
end

cookbook_file '/root/load.sh' do
  source 'load.sh'
  mode 0775
end

cookbook_file '/root/load.sql' do
  source 'load.sql'
end

cookbook_file '/root/normalize.sql' do
  source 'normalize.sql'
end

csvs = %w{
https://s3-us-west-2.amazonaws.com/reinventhackathon/04-open_data-projects.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/01-open_data-donations.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/03-open_data-giftcards.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/05-open_data-resources.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/02-open_data-essays.csv.gz
}
csvs.each do |url|
  file = File.basename(url)
  remote_file "/root/#{file}" do
    source url
  end
end

execute '/root/load.sh' do
  cwd '/root'
  environment 'DBUSER' => 'app',
              'DBHOST' => 'localhost',
              'DBNAME' => 'donorschoose'
end