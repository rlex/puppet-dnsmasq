require 'spec_helper'

describe 'dnsmasq::dnsserver', :type => 'define' do
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

  context 'with minimal params' do
    let :params do { :ip => '192.168.0.4' } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dnsserver-foo').with(
        :order   => '12',
        :target  => 'dnsmasq.conf',
        :content => "server=192.168.0.4\n",
      )
    end
  end

  context 'with all params' do
    let :params do {
      :ip     => '192.168.0.4',
      :domain => 'example.com',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dnsserver-foo').with(
        :order   => '12',
        :target  => 'dnsmasq.conf',
        :content => "server=/example.com/192.168.0.4\n",
      )
    end
  end

end
