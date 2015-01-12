require 'spec_helper'

describe 'dnsmasq::domain', :type => 'define' do
  let :title  do 'example.com' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with no params' do
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-domain-example.com').with(
        :order   => '05',
        :target  => 'dnsmasq.conf',
        :content => "domain=example.com\n",
      )
    end
  end

  context 'with all params' do
    let :params do {
      :subnet => '192.168.0.0/24',
      :local  => true,
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-domain-example.com').with(
        :order   => '05',
        :target  => 'dnsmasq.conf',
        :content => "domain=example.com,192.168.0.0/24,local\n",
      )
    end
  end

end
