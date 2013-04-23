# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcp (
  $dhcp_start,
  $dhcp_end,
  $lease_time
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { 'dnsmasq-dhcprange':
    order   => '01',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dhcp.erb'),
  }

}
