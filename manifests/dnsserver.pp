# Configure the DNS server to query sub domains to external DNS servers
# (--server).
define dnsmasq::dnsserver (
  $ip,
  $domain = undef,
) {
  if !validate_re($ip, '^\d+.\d+.\d+.\d+(#\d+)?$') { fail("Expect IP address for ip, got ${ip}") }

  $domain_real = $domain ? {
    undef   => '',
    default => "/${domain}/",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dnsserver-${name}":
    order   => '12',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsserver.erb'),
  }
}
