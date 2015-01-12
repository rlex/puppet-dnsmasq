require 'spec_helper'

describe 'dnsmasq::txt', :type => 'define' do
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

  context 'with one value' do
    let :params do { :value => 'bar' } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-txt-foo').with(
        :order   => '10',
        :target  => 'dnsmasq.conf',
        :content => "txt-record=foo,bar\n",
      )
    end
  end

  context 'with multiple values' do
    let :params do { :value => ['bar','baz'] } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-txt-foo').with(
        :order   => '10',
        :target  => 'dnsmasq.conf',
        :content => "txt-record=foo,bar,baz\n",
      )
    end
  end
end
