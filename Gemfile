source "https://rubygems.org"

# facter
facter_version = ENV.key?('FACTER_VERSION') ? "= #{ENV['FACTER_VERSION']}" : \
  '= 2.3.0' # from puppet enterprise 3.7
# puppet
puppet_version = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : \
  '= 3.7.3' # from puppet enterprise 3.7

gem 'rake'
gem 'rspec', '< 3.0.0'
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper'
gem 'facter', facter_version
gem 'puppet', puppet_version
