# Create a dnsmasq A,AAAA and PTR record (--host-record).
define dnsmasq::hostrecord (
  $ip,
) {
  if !is_ip_address($ip) { fail("Expect IP address for ip, got ${ip}") }

  include dnsmasq

  concat::fragment { "dnsmasq-hostrecord-${name}":
    order   => '06',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/hostrecord.erb'),
  }

}
