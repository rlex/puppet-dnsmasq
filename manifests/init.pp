# Primary class with options.  See documentation at
# http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html
#
# @param auth_sec_servers
#
# @param auth_server
#
# @param auth_ttl
#
# @param auth_zone
#
# @param bogus_priv
#
# @param cache_size
#
# @param config_hash
#
# @param dhcp_boot
#
# @param dhcp_leasefile
#
# @param dhcp_no_override
#
# @param domain
#
# @param domain_needed
#
# @param dns_forward_max
#
# @param dnsmasq_confdir
#
# @param dnsmasq_conffile
#
# @param dnsmasq_hasstatus
#
# @param dnsmasq_package
#
# @param dnsmasq_package_provider
#
# @param enable_tftp
#
# @param expand_hosts
#
# @param interface
#
# @param listen_address
#
# @param local_ttl
#
# @param manage_tftp_root
#
# @param max_ttl
#
# @param max_cache_ttl
#
# @param neg_ttl
#
# @param no_dhcp_interface
#
# @param no_hosts
#
# @param no_negcache
#
# @param no_resolv
#
# @param port
#
# @param read_ethers
#
# @param reload_resolvconf
#
# @param restart
#
# @param run_as_user
#
# @param save_config_file
#
# @param service_enable
#
# @param service_ensure
#
# @param strict_order
#
# @param tftp_root
#
# @param addresses
#
# @param cnames
#
# @param dhcpboots
#
# @param dhcpmatches
#
# @param dhcpoptions
#
# @param dhcps
#
# @param dhcpstatics
#
# @param dnsrrs
#
# @param dnsservers
#
# @param domains
#
# @param hostrecords
#
# @param mxs
#
# @param ptrs
#
# @param srvs
#
# @param txts
#
# @param dnsmasq_logdir
#
# @param dnsmasq_service
#
# @param resolv_file
#
class dnsmasq (
  Optional[String] $auth_sec_servers                  = undef,
  Optional[String] $auth_server                       = undef,
  Optional[String] $auth_ttl                          = undef,
  Optional[String] $auth_zone                         = undef,
  Boolean $bogus_priv                                 = true,
  String $cache_size                                  = '1000',
  Hash $config_hash                                   = {},
  Optional[Boolean] $dhcp_boot                        = undef,
  Optional[Boolean] $dhcp_leasefile                   = undef,
  Boolean $dhcp_no_override                           = false,
  Optional[String] $domain                            = undef,
  Boolean $domain_needed                              = true,
  Optional[String] $dns_forward_max                   = undef,
  String $dnsmasq_confdir                             = $dnsmasq::params::dnsmasq_confdir,
  String $dnsmasq_conffile                            = $dnsmasq::params::dnsmasq_conffile,
  Boolean $dnsmasq_hasstatus                          = $dnsmasq::params::dnsmasq_hasstatus,
  String $dnsmasq_logdir                              = $dnsmasq::params::dnsmasq_logdir,
  String $dnsmasq_package                             = $dnsmasq::params::dnsmasq_package,
  Optional[String] $dnsmasq_package_provider          = $dnsmasq::params::dnsmasq_package_provider,
  String $dnsmasq_service                             = $dnsmasq::params::dnsmasq_service,
  Boolean $enable_tftp                                = false,
  Boolean $expand_hosts                               = true,
  Optional[Variant[String, Array]] $interface         = undef,
  Optional[String] $listen_address                    = undef,
  Optional[String] $local_ttl                         = undef,
  Boolean $manage_tftp_root                           = false,
  Optional[String] $max_ttl                           = undef,
  Optional[String] $max_cache_ttl                     = undef,
  Optional[String] $neg_ttl                           = undef,
  Optional[Variant[String, Array]] $no_dhcp_interface = undef,
  Boolean $no_hosts                                   = false,
  Boolean $no_negcache                                = false,
  Boolean $no_resolv                                  = false,
  String $port                                        = '53',
  Boolean $read_ethers                                = false,
  Boolean $reload_resolvconf                          = true,
  Boolean $resolv_file                                = false,
  Boolean $restart                                    = true,
  Optional[String] $run_as_user                       = undef,
  Boolean $save_config_file                           = true,
  Boolean $service_enable                             = true,
  String $service_ensure                              = 'running',
  Boolean $strict_order                               = true,
  String $tftp_root                                   = '/var/lib/tftpboot',
  Hash $addresses                                     = {},
  Hash $cnames                                        = {},
  Hash $dhcpboots                                     = {},
  Hash $dhcpmatches                                   = {},
  Hash $dhcpoptions                                   = {},
  Hash $dhcps                                         = {},
  Hash $dhcpstatics                                   = {},
  Hash $dnsrrs                                        = {},
  Hash $dnsservers                                    = {},
  Hash $domains                                       = {},
  Hash $hostrecords                                   = {},
  Hash $mxs                                           = {},
  Hash $ptrs                                          = {},
  Hash $srvs                                          = {},
  Hash $txts                                          = {},
) inherits dnsmasq::params {
  ## CLASS VARIABLES

  # Allow custom ::provider fact to override our provider, but only
  # if it is undef.
  $provider_real = empty($facts['provider']) ? {
    true    => $dnsmasq_package_provider ? {
      undef   => $facts['provider'],
      default => $dnsmasq_package_provider,
    },
    default => $dnsmasq_package_provider,
  }

  ## MANAGED RESOURCES

  concat { 'dnsmasq.conf':
    path    => $dnsmasq_conffile,
    warn    => true,
    require => Package['dnsmasq'],
    notify  => Exec['reload_resolvconf'],
  }

  concat::fragment { 'dnsmasq-header':
    order   => '00',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsmasq.conf.erb'),
  }

  package { 'dnsmasq':
    ensure   => installed,
    name     => $dnsmasq_package,
    provider => $provider_real,
    before   => Service['dnsmasq'],
  }

  service { 'dnsmasq':
    ensure    => $service_ensure,
    name      => $dnsmasq_service,
    enable    => $service_enable,
    hasstatus => $dnsmasq_hasstatus,
  }

  if $restart {
    Concat['dnsmasq.conf'] ~> Service['dnsmasq']
  }

  if $dnsmasq_confdir {
    file { $dnsmasq_confdir:
      ensure => 'directory',
      owner  => 0,
      group  => 0,
      mode   => '0755',
    }
  }

  if $save_config_file {
    # let's save the commented default config file after installation.
    exec { 'save_config_file':
      command => "cp ${dnsmasq_conffile} ${dnsmasq_conffile}.orig",
      creates => "${dnsmasq_conffile}.orig",
      path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',],
      require => Package['dnsmasq'],
      before  => Concat['dnsmasq.conf'],
    }
  }

  if $reload_resolvconf {
    exec { 'reload_resolvconf':
      provider    => shell,
      command     => '/sbin/resolvconf -u',
      path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',],
      user        => 'root',
      onlyif      => 'test -f /sbin/resolvconf',
      before      => Service['dnsmasq'],
      require     => Package['dnsmasq'],
      refreshonly => true,
    }
  }

  if $manage_tftp_root {
    file { $tftp_root:
      ensure => directory,
      owner  => 0,
      group  => 0,
      mode   => '0644',
      before => Service['dnsmasq'],
    }
  }

  if !empty($addresses) {
    create_resources('dnsmasq::address', $addresses)
  }
  if !empty($cnames) {
    create_resources('dnsmasq::cname', $cnames)
  }
  if !empty($dhcpboots) {
    create_resources('dnsmasq::dhcpboot', $dhcpboots)
  }
  if !empty($dhcpmatches) {
    create_resources('dnsmasq::dhcpmatch', $dhcpmatches)
  }
  if !empty($dhcpoptions) {
    create_resources('dnsmasq::dhcpoption', $dhcpoptions)
  }
  if !empty($dhcps) {
    create_resources('dnsmasq::dhcp', $dhcps)
  }
  if !empty($dhcpstatics) {
    create_resources('dnsmasq::dhcpstatic', $dhcpstatics)
  }
  if !empty($dnsrrs) {
    create_resources('dnsmasq::dnsrr', $dnsrrs)
  }
  if !empty($dnsservers) {
    create_resources('dnsmasq::dnsserver', $dnsservers)
  }
  if !empty($domains) {
    create_resources('dnsmasq::domain', $domains)
  }
  if !empty($hostrecords) {
    create_resources('dnsmasq::hostrecord', $hostrecords)
  }
  if !empty($mxs) {
    create_resources('dnsmasq::mx', $mxs)
  }
  if !empty($ptrs) {
    create_resources('dnsmasq::ptr', $ptrs)
  }
  if !empty($srvs) {
    create_resources('dnsmasq::srv', $srvs)
  }
  if !empty($txts) {
    create_resources('dnsmasq::txt', $txts)
  }

  if ! $no_hosts {
    Host <||> {
      notify +> Service['dnsmasq'],
    }
  }
}
