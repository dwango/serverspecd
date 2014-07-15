require 'spec_helper'
properties = property['zabbix-agent']

describe package('zabbix-agent') do
  it { should be_installed }
end

describe service('zabbix-agent') do
  it { should be_enabled }
  it { should be_running }
end

describe command('zabbix_agentd -V') do
  it { should return_stdout /#{properties[:version]}/ }
end
