# Create an dnsmasq A record.
define dnsmasq::address (
  $ip,
) {
  if !is_ip_address($ip) { fail("Expect IP address for ip, got ${ip}") }

  include dnsmasq

  concat::fragment { "dnsmasq-staticdns-${name}":
    order   => "06_${name}",
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/address.erb'),
  }

}
