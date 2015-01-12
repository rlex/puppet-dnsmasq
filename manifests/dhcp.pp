# Create an dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-range).
define dnsmasq::dhcp (
  $dhcp_start,
  $dhcp_end,
  $netmask,
  $lease_time,
  $paramtag = undef,
  $paramset = undef,
) {
  $paramset_real = $paramset ? {
    undef   => '',
    default => "set:${paramset},",
  }
  $paramtag_real = $paramtag ? {
    undef   => '',
    default => "tag:${paramtag},",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dhcprange-${name}":
    order   => '01',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcp.erb'),
  }

}
