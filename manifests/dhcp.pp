# Create an dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-range).
#
# @param dhcp_start
#
# @param dhcp_end
#
# @param netmask
#
# @param lease_time
#
# @param tag
#
# @param set
#
# @param mode
#
define dnsmasq::dhcp (
  String $dhcp_start,
  String $dhcp_end,
  String $netmask,
  String $lease_time,
  Optional[String] $tag  = undef,
  Optional[String] $set  = undef,
  Optional[String] $mode = undef,
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
