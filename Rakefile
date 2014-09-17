require 'rake'

require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

PuppetLint.configuration.send('disable_autoloader_layout')

task :default => [:spec, :lint]
