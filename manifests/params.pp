# Detect OS, set os-specific parameters
class dnsmasq::params {
  $dnsmasq_conffile = $facts['os']['family'] ? {
    'Darwin'                => '/opt/local/etc/dnsmasq.conf',
    /^(DragonFly|FreeBSD)$/ => '/usr/local/etc/dnsmasq.conf',
    default                 => '/etc/dnsmasq.conf',
  }
  $dnsmasq_hasstatus = $facts['os']['family'] ? {
    'RedHat' => true,
    default  => false,
  }
  $dnsmasq_logdir = $facts['os']['family'] ? {
    'Darwin'                => '/opt/local/var/log/dnsmasq',
    /^(DragonFly|FreeBSD)$/ => '/var/log/dnsmasq',
    default                 => '/var/log',
  }
  $dnsmasq_confdir = $facts['os']['family'] ? {
    'Darwin'                => '/opt/local/etc/dnsmasq.d',
    /^(DragonFly|FreeBSD)$/ => '/usr/local/etc/dnsmasq.d',
    default                 => '/etc/dnsmasq.d',
  }
  $dnsmasq_service = $facts['os']['family'] ? {
    'Darwin' => 'org.macports.dnsmasq',
    default  => 'dnsmasq',
  }
  $dnsmasq_package = $facts['os']['family'] ? {
    /^(DragonFly|FreeBSD)$/ => 'dns/dnsmasq',
    default                 => 'dnsmasq',
  }
  $dnsmasq_package_provider = $facts['os']['family'] ? {
    'Darwin' => 'macports',
    default  => undef,
  }
}
