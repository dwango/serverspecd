require 'spec_helper'
p = property['mysql_server']

describe file('/usr/local/mysql') do
    it { should be_linked_to "/usr/local/mysql-#{p[:version]}" }
end

describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
end

describe user(p[:user]) do
    it { should exist }
end

describe port(p[:listen_port]) do
    it { should be_listening }
end

describe file('/etc/my.cnf') do
    it { should be_file }
    it { should contain "innodb_file_per_table" }
    it { should contain "innodb_buffer_pool_size=#{p[:innodb_buffer_pool_size]}" }
    it { should contain "innodb_log_file_size=#{p[:innodb_log_file_size]}" }
    it { should contain "innodb_log_files_in_group=#{p[:innodb_log_files_in_group]}" }
    it { should contain "character-set-server=utf8" }
end
