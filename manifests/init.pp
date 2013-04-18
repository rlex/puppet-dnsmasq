class dnsmasq (
  $interface = 'eth0',
  $domain = 'int.lan',
  $expand_hosts = true,
  $enable_tftp = false,
  $tftp_root = '/var/lib/tftpboot',
  $dhcp_boot = 'pxelinux.0',
  $domain_needed = true,
  $bogus_priv = true,
) {
  include dnsmasq::params
  include concat::setup

  # Localize some variables
  $dnsmasq_package     = $dnsmasq::params::dnsmasq_package
  $dnsmasq_confdir     = $dnsmasq::params::dnsmasq_conffile
  $dnsmasq_logdir      = $dnsmasq::params::dnsmasq_logdir
  $dnsmasq_service     = $dnsmasq::params::dnsmasq_service

  package { $dnsmasq_package:
    ensure   => installed,
    provider => $provider,
  }

  service { $dnsmasq_service:
    ensure    => running,
    name      => $dnsmasq_service,
    enable    => true,
    hasstatus => false,
    require   => Package[$dnsmasq_package],
  }

  concat::fragment { 'dnsmasq-header':
    order   => '00',
    target  => "${dnsmasq_conffile}",
    content => template('dnsmasq/dnsmasq.conf.erb'),
    require => Package[$dnsmasq_package],
  }

  concat { "${dnsmasq_conffile}":
    notify  => Service[$dnsmasq_service],
    require => Package[$dnsmasq_package],
  }

}

