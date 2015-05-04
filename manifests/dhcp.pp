# Create an dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-range).
define dnsmasq::dhcp (
  $dhcp_start,
  $dhcp_end,
  $netmask,
  $lease_time,
  $tag = undef,
  $set = undef,
  $mode = undef,
) {
  $set_real = $set ? {
    undef   => '',
    default => "set:${set},",
  }
  $tag_real = $tag ? {
    undef   => '',
    default => "tag:${tag},",
  }
  $mode_real = $mode ? {
    undef => '',
    default => "${mode},"
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dhcprange-${name}":
    order   => '01',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcp.erb'),
  }

}
