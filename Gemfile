source "https://rubygems.org"

# puppet
puppet_version = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : \
  '= 3.7.2' # from puppet enterprise 3.7.0

gem 'rake'
gem 'rspec', '< 3.0.0'
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper'
gem 'puppet', puppet_version
