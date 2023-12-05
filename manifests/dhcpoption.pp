# Create an dnsmasq dhcp option (--dhcp-option).
#
# @param option
#
# @param content
#
# @param tag
#
define dnsmasq::dhcpoption (
  String $option,
  String $content,
  Optional[String] $tag = undef,
) {
  $tag_real = $tag ? {
    undef   => '',
    default => "tag:${tag},",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dhcpoption-${name}":
    order   => '02',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpoption.erb'),
  }
}
