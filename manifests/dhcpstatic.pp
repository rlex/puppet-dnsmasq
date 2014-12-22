# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcpstatic (
  $mac,
  $ip,
) {
  if !is_ip_address($ip)  { fail("Expect IP address for ip, got ${ip}") }
  if !is_ip_address($mac) { fail("Expect MAC address for mac, got ${mac}") }

  include dnsmasq

  concat::fragment { "dnsmasq-staticdhcp-${name}":
    order   => '04',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpstatic.erb'),
  }

}
