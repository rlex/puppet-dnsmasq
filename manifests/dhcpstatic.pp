# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcpstatic (
  $mac,
  $ip,
) {
  $mac_real = downcase($mac)

  if !is_ip_address($ip) { fail("Expect IP address for ip, got ${ip}") }
  validate_re($mac_real,
    '^[a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}$',
    "Expect MAC address for mac, got ${mac}")

  include dnsmasq

  concat::fragment { "dnsmasq-staticdhcp-${name}":
    order   => '04',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpstatic.erb'),
  }

}
