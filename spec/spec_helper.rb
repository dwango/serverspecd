require 'serverspec'
require 'net/ssh'
require 'yaml'
require 'pry'

set :backend, :ssh

properties = YAML.load_file("attributes.yml")

set :request_pty, true
set :path, '/sbin:/usr/local/sbin:$PATH'
set :host, ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)
set :ssh_options, :user => options[:user] || Etc.getlogin

set_property properties
