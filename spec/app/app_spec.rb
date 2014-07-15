require 'spec_helper'
properties = property['app']

properties[:users].map do |u|
  describe user(u) do
   it { should exist }
  end
end

properties[:directories].map do |d|
  describe file(d['directory']) do
    it { should be_directory }
    it { should be_owned_by d['user'] }
    it { should be_mode d['mode'] }
  end
end
