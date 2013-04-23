#Detect OS, set os-specific parameters
class dnsmasq::params {
  case $::operatingsystem {
    'ubuntu', 'debian': {
      $dnsmasq_conffile = '/etc/dnsmasq.conf'
      $dnsmasq_logdir = '/var/log'
      $dnsmasq_service = 'dnsmasq'
      $dnsmasq_package = 'dnsmasq'
    }
    'redhat', 'centos', 'scientific': {
      $dnsmasq_conffile = '/etc/dnsmasq.conf'
      $dnsmasq_logdir = '/var/log'
      $dnsmasq_service = 'dnsmasq'
      $dnsmasq_package = 'dnsmasq'
    }
    'darwin': {
      $dnsmasq_conffile = '/opt/local/etc/dnsmasq.conf'
      $dnsmasq_logdir  = '/opt/local/var/log/dnsmasq'
      $dnsmasq_service = 'org.macports.dnsmasq'
      $dnsmasq_package = 'dnsmasq'
    }
    'freebsd': {
      $dnsmasq_conffile = '/usr/local/etc/dnsmasq.conf'
      $dnsmasq_logdir  = '/var/log/dnsmasq'
      $dnsmasq_service = 'dnsmasq'
      $dnsmasq_package = 'dns/dnsmasq'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
