# Detect OS, set os-specific parameters
class dnsmasq::params {
  validate_re($::osfamily,[
    '^Darwin$',
    '^Debian$',
    '^DragonFly$',
    '^FreeBSD$',
    '^RedHat$',
  ],"Module ${module_name} is not supported on ${::operatingsystem}")

  $dnsmasq_conffile = $::osfamily ? {
    'Darwin'                => '/opt/local/etc/dnsmasq.conf',
    /^(DragonFly|FreeBSD)$/ => '/usr/local/etc/dnsmasq.conf',
    default                 => '/etc/dnsmasq.conf',
  }
  $dnsmasq_hasstatus = $::osfamily ? {
    'RedHat' => true,
    default  => false,
  }
  $dnsmasq_logdir = $::osfamily ? {
    'Darwin'                => '/opt/local/var/log/dnsmasq',
    /^(DragonFly|FreeBSD)$/ => '/var/log/dnsmasq',
    default                 => '/var/log',
  }
  $dnsmasq_confdir = $::osfamily ? {
    'Darwin'                => '/opt/local/etc/dnsmasq.d',
    /^(DragonFly|FreeBSD)$/ => '/usr/local/etc/dnsmasq.d',
    default                 => '/etc/dnsmasq.d',
  }
  $dnsmasq_service = $::osfamily ? {
    'Darwin' => 'org.macports.dnsmasq',
    default  => 'dnsmasq',
  }
  $dnsmasq_package = $::osfamily ? {
    /^(DragonFly|FreeBSD)$/ => 'dns/dnsmasq',
    default                 => 'dnsmasq',
  }
  $dnsmasq_package_provider = $::osfamily ? {
    'Darwin' => 'macports',
    default  => undef,
  }
}
