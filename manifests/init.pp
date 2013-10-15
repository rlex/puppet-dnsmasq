#Primary class with options
class dnsmasq (
  $interface = undef,
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
  $no_negcache = false,
  $no_hosts = false,
  $resolv_file = false,
  $cache_size = 1000,
  $confdir_path = false
) {
  include dnsmasq::params
  include concat::setup

  # Localize some variables
  $dnsmasq_package     = $dnsmasq::params::dnsmasq_package
  $dnsmasq_conffile     = $dnsmasq::params::dnsmasq_conffile
  $dnsmasq_logdir      = $dnsmasq::params::dnsmasq_logdir
  $dnsmasq_service     = $dnsmasq::params::dnsmasq_service
  if $confdir_path == false {
    $dnsmasq_confdir = $dnsmasq::params::dnsmasq_confdir
  } else {
          $dnsmasq_confdir = $confdir_path
  }

  package { $dnsmasq_package:
    ensure   => installed,
    provider => $::provider,
  }

  service { $dnsmasq_service:
    ensure    => running,
    name      => $dnsmasq_service,
    enable    => true,
    hasstatus => false,
    require   => Package[$dnsmasq_package],
  }

  file { $dnsmasq_confdir:
    ensure => 'directory',
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

