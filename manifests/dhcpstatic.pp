# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcpstatic (
  $mac,
  $ip,
) {
  validate_re($mac,'^\h{2}:\h{2}:\h{2}:\h{2}:\h{2}:\h{2}$')
  if !is_ip_address($ip)  { fail("Expect IP address for ip, got ${ip}") }

  include dnsmasq

  concat::fragment { "dnsmasq-staticdhcp-${name}":
    order   => '04',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpstatic.erb'),
  }

}
