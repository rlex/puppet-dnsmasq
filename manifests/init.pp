#Primary class with options
class dnsmasq (
  $interface = undef,
  $no_dhcp_interface = undef,
  $listen_address = undef,
  $domain = undef,
  $expand_hosts = true,
  $port = '53',
  $enable_tftp = false,
  $tftp_root = '/var/lib/tftpboot',
  $dhcp_boot = undef,
  $strict_order = true,
  $domain_needed = true,
  $bogus_priv = true,
  $dhcp_no_override = false,
  $no_negcache = false,
  $no_hosts = false,
  $resolv_file = false,
  $cache_size = 1000,
  $confdir_path = '__default__',
  $config_hash = {},
  $service_ensure = 'running',
  $service_enable = true,
  $auth_server = undef,
  $auth_sec_servers = undef,
  $auth_zone = undef,
  $run_as_user = undef,
) {

  include dnsmasq::params

  validate_bool($service_enable)

  # Localize some variables
  $dnsmasq_package     = $dnsmasq::params::dnsmasq_package
  $dnsmasq_conffile     = $dnsmasq::params::dnsmasq_conffile
  $dnsmasq_logdir      = $dnsmasq::params::dnsmasq_logdir
  $dnsmasq_service     = $dnsmasq::params::dnsmasq_service

  if $confdir_path == '__default__' {
    $dnsmasq_confdir = $dnsmasq::params::dnsmasq_confdir
  } elsif $confdir_path {
          $dnsmasq_confdir = $confdir_path
  }

  package { $dnsmasq_package:
    ensure   => installed,
    provider => $::provider,
    before => Exec['reload_resolvconf'],
  }

  # let's save the commented default config file after installation.
  exec { 'save_config_file':
    command => "cp ${dnsmasq_conffile} ${dnsmasq_conffile}.orig",
    creates => "${dnsmasq_conffile}.orig",
    path    => [ "/usr/bin", "/usr/sbin", "/bin", "/sbin", ],
    require => Package[$dnsmasq_package],
    before  => File[$dnsmasq_conffile],
  }

  service { 'dnsmasq':
    ensure    => $service_ensure,
    name      => $dnsmasq_service,
    enable    => $service_enable,
    hasstatus => false,
    require   => Package[$dnsmasq_package],
  }
  
  exec { 'reload_resolvconf':
    provider => shell,
    command => "/sbin/resolvconf -u",
    user => root,
    onlyif => "test -f /sbin/resolvconf",
    before => Service['dnsmasq'],
  }

  if $dnsmasq_confdir {
    file { $dnsmasq_confdir:
      ensure => 'directory',
    }
  }
  
  if ! $no_hosts {
    Host <||> { 
      notify +> Service[$dnsmasq::params::dnsmasq_service],
    }
  }

  concat::fragment { 'dnsmasq-header':
    order   => '00',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dnsmasq.conf.erb'),
    require => Package[$dnsmasq_package],
  }

  concat { $dnsmasq_conffile:
    notify  => Service[$dnsmasq_service],
    require => Package[$dnsmasq_package],
  }

}

