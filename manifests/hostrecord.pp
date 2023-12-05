# Create a dnsmasq A,AAAA and PTR record (--host-record).
#
# @param ip
#
# @param ipv6
#
define dnsmasq::hostrecord (
  String $ip,
  Optional[String] $ipv6 = undef,
) {
  include dnsmasq

  $ipv6_real = $ipv6 ? {
    undef   => '',
    default => ",${ipv6}",
  }

  concat::fragment { "dnsmasq-hostrecord-${name}":
    order   => '06',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/hostrecord.erb'),
  }
}
