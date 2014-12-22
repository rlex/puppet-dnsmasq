require 'spec_helper'

describe 'dnsmasq::hostrecord', :type => 'define' do
  let :title  do 'example.com' end
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
    let :params do { :ip => '192.168.0.4' } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-hostrecord-example.com').with(
        :order   => '06',
        :target  => 'dnsmasq.conf',
        :content => "host-record=example.com,192.168.0.4\n",
      )
    end
  end

end
