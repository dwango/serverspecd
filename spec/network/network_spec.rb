require 'spec_helper'
properties = property['network']

# disable service check
properties[:reachable].map do |a|
  describe host(a) do
    it { should be_reachable }
    it { should be_reachable.with( :port => 80, :proto => 'tcp' ) }
  end
end

# network
describe default_gateway do
  its(properties[:ipaddress]) { should eq p['gw_addr'] }
  its(properties[:interface]) { should eq p['gw_addr_device'] }
end

describe service('network') do
  it { should be_enabled }
  it { should be_running }
end
