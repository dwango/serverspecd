require 'spec_helper'
properties = property['php']

describe 'PHP config parameters' do

  context php_config('date.timezone') do
    its(:value) { should eq properties[:timezone] }
  end

  context php_config('max_execution_time') do
    its(:value) { should eq properties[:max_execution_time] }
  end

  context php_config('memory_limit') do
    its(:value) { should eq properties[:memory_limit] }
  end

  context php_config('post_max_size') do
    its(:value) { should eq properties[:post_max_size] }
  end

  context php_config('upload_max_filesize') do
    its(:value) { should eq properties[:upload_max_filesize] }
  end

  context php_config('max_input_time') do
    its(:value) { should eq "#{properties[:max_input_time]}" }
 end

end


describe command('libmcrypt-config --version') do
  its(:stdout) { should match properties[:libmcrypt_version] }
end

describe command('php -v') do
  its(:stdout) { should match /#{properties[:version]}/ }
end
