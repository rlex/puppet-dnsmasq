# Configure the DNS server to query sub domains to external DNS servers
# (--server).
#
# @param ip
#
# @param domain
#
# @param port
#
define dnsmasq::dnsserver (
  String $ip,
  String $domain         = undef,
  Optional[String] $port = undef,
) {
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
    order   => '12',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsserver.erb'),
  }
}
