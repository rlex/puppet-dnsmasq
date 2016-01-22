# Create a dnsmasq A,AAAA and PTR record (--host-record).
define dnsmasq::hostrecord (
  $ip,
  $ipv6 = undef,
) {
  if !is_ip_address($ip) { fail("Expect IP address for ip, got ${ip}") }

  include dnsmasq

  $ipv6_real = $ipv6 ? {
    undef   => '',
    default => ",${ipv6}",
  }

  concat::fragment { "dnsmasq-hostrecord-${name}":
    order   => '07',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/hostrecord.erb'),
  }

}
