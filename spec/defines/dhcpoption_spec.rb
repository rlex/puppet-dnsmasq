require 'spec_helper'

describe 'dnsmasq::dhcpoption', :type => 'define' do
  let :title  do 'option:ntp-server' end
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

  context 'with minimal parms' do
    let :params do { :content => '192.168.0.4' } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dhcpoption-option:ntp-server'
                                     ).with(
        :order   => '02',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-option=option:ntp-server,192.168.0.4\n",
      )
    end
  end

  context 'with all parms' do
    let :params do {
      :content  => '192.168.0.4',
      :tag => 'foo',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dhcpoption-option:ntp-server'
                                     ).with(
        :order   => '02',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-option=tag:foo,option:ntp-server,192.168.0.4\n",
      )
    end
  end

end
