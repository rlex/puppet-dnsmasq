# Create a dnsmasq A record (--address).
define dnsmasq::address (
  $ip,
) {
  validate_slength($name,255) # hostnames cannot be longer
  if !is_ip_address($ip) { fail("Expect IP address for ip, got ${ip}") }

  include dnsmasq

  concat::fragment { "dnsmasq-staticdns-${name}":
    order   => "07_${name}",
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/address.erb'),
  }

}
