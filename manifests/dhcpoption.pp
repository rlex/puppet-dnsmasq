# Create an dnsmasq dhcp option (--dhcp-option).
define dnsmasq::dhcpoption (
  $content,
  $paramtag = undef,
) {
  $paramtag_real = $paramtag ? {
    undef   => '',
    default => "tag:${paramtag},",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dhcpoption-${name}":
    order   => '02',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpoption.erb'),
  }

}
