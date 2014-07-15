require 'serverspec'
require 'net/ssh'
require 'yaml'
require 'pry'
 
include Serverspec::Helper::Ssh
include Serverspec::Helper::DetectOS

properties = YAML.load_file("attributes.yml")

RSpec.configure do |c|
  c.request_pty = true
  c.path  = '/sbin:/usr/sbin'
  c.host  = ENV['TARGET_HOST']
  options = Net::SSH::Config.for(c.host)
  user    = options[:user] || Etc.getlogin
  c.ssh   = Net::SSH.start(c.host, user, options)
  c.os    = backend(Serverspec::Commands::Base).check_os
  set_property properties
end
