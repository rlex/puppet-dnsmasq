# Configure the DNS server to query sub domains to external DNS servers
define dnsmasq::dnsserver (
  $ip,
  $domain = undef,
) {
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
