# Create an dnsmasq dhcp option.
define dnsmasq::dhcpoption (
  $subnet = undef,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-domain-${name}":
    order   => '02',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/domain.erb'),
  }

}
