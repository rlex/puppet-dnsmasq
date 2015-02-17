require 'spec_helper'

describe 'dnsmasq', :type => 'class' do

  shared_context 'supported' do
    it { should contain_concat('dnsmasq.conf'
                              ).that_requires('Package[dnsmasq]') }
    it { should contain_concat__fragment('dnsmasq-header').with({
      :name    => 'dnsmasq-header',
      :order   => '00',
      :target  => 'dnsmasq.conf',
      :content => /^# MAIN CONFIG START\ndomain-needed\nbogus-priv/,
    }) }
    it { should contain_package('dnsmasq'
                               ).that_comes_before('Service[dnsmasq]') }
    it { should contain_service('dnsmasq') }
    it { should contain_exec('reload_resolvconf') }
    it { should contain_exec('save_config_file') }
  end

  shared_context 'unsupported' do
    it { expect { should compile }.to raise_error(
      Puppet::Error, /Module dnsmasq is not supported on/) }
  end

  basefacts = { :concat_basedir => '/foo/bar/baz' }

  context 'on an unsupported OS' do
    let :facts do basefacts.merge({
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }) end
    it_behaves_like 'unsupported'
  end

  [ basefacts.merge({:osfamily => 'Darwin',   :operatingsystem => 'Darwin'   }),
    basefacts.merge({:osfamily => 'Debian',   :operatingsystem => 'Ubuntu'   }),
    basefacts.merge({:osfamily => 'DragonFly',:operatingsystem => 'DragonFly'}),
    basefacts.merge({:osfamily => 'FreeBSD',  :operatingsystem => 'FreeBSD'  }),
    basefacts.merge({:osfamily => 'RedHat',   :operatingsystem => 'CentOS'   }),
  ].each { |facts|

    context "on OS family #{facts[:osfamily]}" do
      let :facts do facts end

      it_behaves_like 'supported'

      case facts[:osfamily]
      when 'Darwin' then
        it { should contain_concat('dnsmasq.conf'
                                  ).with_path('/opt/local/etc/dnsmasq.conf') }
        it { should contain_package('dnsmasq').with({
          :name     => 'dnsmasq',
          :provider => 'macports',
        }) }
      when 'Debian','RedHat' then
        it { should contain_concat('dnsmasq.conf'
                                  ).with_path('/etc/dnsmasq.conf') }
        it { should contain_package('dnsmasq').with({
          :name     => 'dnsmasq',
          :provider => nil,
        }) }
      when 'DragonFly','FreeBSD' then
        it { should contain_concat('dnsmasq.conf'
                                  ).with_path('/usr/local/etc/dnsmasq.conf') }
        it { should contain_package('dnsmasq').with({
          :name     => 'dns/dnsmasq',
          :provider => nil,
        }) }
      end

      context 'with reload_resolvconf = false' do
        let :params do { :reload_resolvconf => false } end
        it { should_not contain_exec('reload_resolvconf') }
      end

      context 'with save_config_file = false' do
        let :params do { :save_config_file => false } end
        it { should_not contain_exec('save_config_file') }
      end

      # Test our booleans
      [ 'bogus_priv',
        'domain_needed',
        'dhcp_no_override',
        'enable_tftp',
        'expand_hosts',
        'no_hosts',
        'no_negcache',
        'no_resolv',
        'read_ethers',
        'strict_order',
      ].each { |i|
        param = i.gsub('_','-')

        context "with #{i} = true" do
          let :params do { i => true } end
          it { should contain_concat__fragment('dnsmasq-header').with_content(
            /\n#{param}\n/
          ) }
        end

        context "with #{i} = false" do
          let :params do { i => false } end
          it { should contain_concat__fragment('dnsmasq-header').with_content(
            /(?!#{param})/
          ) }
        end
      }
    end
  }
end
