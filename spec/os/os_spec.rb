require 'spec_helper'
properties = property['os']

# ntpd check
describe package('ntpdate') do
  it { should be_installed }
end

describe service('ntpd') do
  it { should be_enabled }
  it { should be_running }
end

# アスタリスク "*" が左端に表示され参照中であること
describe command('ntpq -pn') do
  its(:stdout) { should match /^\*\d/ }
end

# packages install check
properties[:packages].map do |a|
  describe package(a) do
    it { should be_installed }
  end
end

# disable service check
properties[:disable_services].map do |a|
  describe command('service ' + a + ' status') do
    its(:exit_status) { should_not eq 0 }
  end
end

describe service('network') do
  it { should be_enabled }
  it { should be_running }
end

# resolv.conf
properties[:resolv].map do |s|
  describe command('cat /etc/resolv.conf') do
    it { should eq s }
  end
end

# resolve check
describe host('www.google.com') do
  it { should be_resolvable.by('dns') }
end

# other hosts
describe host('localhost') do
  # ping
  it { should be_reachable }
  # tcp port 22
  it { should be_reachable.with( :port => 22 ) }
  # set protocol explicitly
  it { should be_reachable.with( :port => 22, :proto => 'tcp' ) }
end

# hostname
describe command('hostname') do
  its(:stdout) { should eq p[:hostname] }
end

# selinux
describe selinux do
  it { should be_disabled }
end

# format type
describe file('/') do
  it { should be_mounted.with( :type => 'ext4' ) }
end

describe package('openssh') do
  it { should be_installed }
end

# SSH
describe service('sshd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(22) do
  it { should be_listening }
end

describe file('/etc/ssh/sshd_config') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'root' }
  it { should contain 'PermitRootLogin no' }
  it { should contain 'PasswordAuthentication no' }
  it { should contain 'PermitEmptyPasswords no' }
  it { should contain 'GSSAPIAuthentication no' }
  it { should contain 'UseDNS no'}
end

describe file('/etc/sudoers') do
  it { should be_file }
  it { should be_mode 440 }
  it { should be_owned_by 'root' }
  it { should contain 'root	ALL=(ALL) 	ALL' }
end

describe file('/etc/sysctl.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should contain 'net.ipv4.ip_local_port_range = 10000 65000' }
  it { should contain 'fs.file-max = 357409' }
end

describe file('/etc/pam.d/su') do
  it { should be_file }
  it { should be_owned_by 'root' }
end

describe file('/etc/login.defs') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should contain 'SU_WHEEL_ONLY yes' }
end

describe file('/etc/security/limits.d/90-nproc.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 644 }
end

describe file('/etc/security/limits.d/file_descriptor.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 644 }
  it { should contain '*          soft    nproc     65535' }
  it { should contain 'root       soft    nproc     unlimited' }
end

describe file('/etc/sysconfig/i18n') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 644 }
end

describe file('/etc/hosts') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 644 }
end

describe file('/home/src') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 755 }
end
