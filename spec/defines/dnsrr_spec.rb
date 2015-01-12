require 'spec_helper'

describe 'dnsmasq::dnsrr', :type => 'define' do
  let :title  do 'foo' end
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

  context 'with params' do
    let :params do {
      :domain => 'example.com',
      :type   => '51',
      :rdata  => '01 23 45',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dnsrr-foo').with(
        :order   => '11',
        :target  => 'dnsmasq.conf',
        :content => "dns-rr=example.com,51,012345\n",
      )
    end
  end
  context 'with other params' do
    let :params do {
      :domain => 'example.com',
      :type   => '51',
      :rdata  => '01:23:45',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dnsrr-foo').with(
        :order   => '11',
        :target  => 'dnsmasq.conf',
        :content => "dns-rr=example.com,51,012345\n",
      )
    end
  end

end
