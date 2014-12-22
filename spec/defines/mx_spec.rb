require 'spec_helper'

describe 'dnsmasq::mx', :type => 'define' do
  let :title  do 'example.com' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with no params' do
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-mx-example.com').with(
        :order   => '07_example.com__',
        :target  => 'dnsmasq.conf',
        :content => "mx-host=example.com\n",
      )
    end
  end

  context 'with all params' do
    let :params do {
      :mx_name    => 'my.example.com',
      :hostname   => 'example.com',
      :preference => '50',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-mx-example.com').with(
        :order   => '07_my.example.com_,example.com_,50',
        :target  => 'dnsmasq.conf',
        :content => "mx-host=my.example.com,example.com,50\n",
      )
    end
  end

end
