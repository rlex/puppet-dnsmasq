require 'spec_helper'

describe 'dnsmasq::cname', :type => 'define' do
  let :title  do 'foo.com' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with no params' do
    it 'should raise error due no params' do
      expect { should compile }.to raise_error(Puppet::Error,/Must pass/)
    end
  end

  context 'with hostname' do
    let :params do { :hostname => 'example.com' } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-cname-foo.com').with(
        :order   => '11',
        :target  => 'dnsmasq.conf',
        :content => "cname=foo.com,example.com\n",
      )
    end
  end

end
