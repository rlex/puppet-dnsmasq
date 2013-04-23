# Create an dnsmasq dhcp option.
define dnsmasq::dhcpoption (
  $content,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dhcpoption-${name}":
    order   => '02',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dhcpoption.erb'),
  }

}
