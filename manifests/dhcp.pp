# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcp (
  $paramtag = undef,
  $paramset = undef,
  $dhcp_start,
  $dhcp_end,
  $netmask,
  $lease_time
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dhcprange-${name}":
    order   => '01',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dhcp.erb'),
  }

}
