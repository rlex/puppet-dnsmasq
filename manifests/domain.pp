# Create an dnsmasq domains.
define dnsmasq::domain (
  $subnet = undef,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-domain-${name}":
    order   => '05',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/domain.erb'),
  }

}
