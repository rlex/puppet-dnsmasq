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

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' and RUBY_VERSION < '1.9'
  # rake >=11 does not support ruby 1.8.7
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 10.0'
end
