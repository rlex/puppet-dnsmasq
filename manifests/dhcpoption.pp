# Create an dnsmasq dhcp option (--dhcp-option).
define dnsmasq::dhcpoption (
  $option,
  $content,
  $tag = undef,
) {
  $tag_real = $tag ? {
    undef   => '',
    default => "tag:${tag},",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dhcpoption-${name}":
    order   => '03',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpoption.erb'),
  }

}
