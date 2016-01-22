# Configure the DNS server to query sub domains to external DNS servers
# (--server).
define dnsmasq::dnsserver (
  $ip,
  $domain = undef,
  $port = undef,
) {
  if !is_ip_address($ip) { fail("Expect IP address for ip, got ${ip}") }

  $domain_real = $domain ? {
    undef   => '',
    default => "/${domain}/",
  }

  $port_real = $port ? {
    undef   => '',
    default => "#${port}",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dnsserver-${name}":
    order   => '13',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsserver.erb'),
  }
}
