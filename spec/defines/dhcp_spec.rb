require 'spec_helper'

describe 'dnsmasq::dhcp', :type => 'define' do
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
      :dhcp_start => '1.2.3.128',
      :dhcp_end   => '1.2.3.192',
      :netmask    => '24',
      :lease_time => '1h',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dhcprange-foo').with(
        :order   => '01',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-range=1.2.3.128,1.2.3.192,24,1h\n",
      )
    end
  end

end
