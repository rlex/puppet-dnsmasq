require 'rake'
require 'json'

require 'rspec/core/rake_task'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

#RSpec::Core::RakeTask.new(:spec) do |t|
#  t.pattern = 'spec/*/*_spec.rb'
#end

#PuppetLint.configuration.send('disable_autoloader_layout')

#task :default => [:spec, :lint]
PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]
