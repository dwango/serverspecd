require 'rake'
require 'rspec/core/rake_task'
require 'yaml'
require 'pry'
 
hosts      = YAML.load_file("hosts.yml").to_a

hosts = hosts.map do |key, value| 
  {
    :name       => key,
    :short_name => key,
    :roles      => value[:roles],
  }
end

desc "Run serverspec to all hosts"
task :serverspec => 'serverspec:all'
 
namespace :serverspec do
  task :all => hosts.map {|h| 'serverspec:' + h[:short_name] }
  hosts.each do |host|
    desc "Run serverspec to #{host[:name]}"
      RSpec::Core::RakeTask.new(host[:short_name].to_sym) do |t|
        ENV['TARGET_HOST'] = host[:name]
        t.pattern = 'spec/{' + host[:roles].join(',') + '}/*_spec.rb'
      end
  end
end
