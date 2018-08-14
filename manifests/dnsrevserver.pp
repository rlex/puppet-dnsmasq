# Configure the DNS server to query sub domains to external DNS servers
# (--rev-server).
define dnsmasq::dnsrevserver (
  $ip,
  $netmask,
  $subnet,
  $port = undef,
) {
  if !is_ip_address($ip) { fail("Expect IP address for ip, got ${ip}") }
  if !is_ip_address($subnet) { fail("Expect IP address for subnet, got ${subnet}") }

  $port_real = $port ? {
    undef   => '',
    default => "#${port}",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dnsserver-${name}":
    order   => '13',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsrevserver.erb'),
  }
}
