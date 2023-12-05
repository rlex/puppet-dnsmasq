# Create an dnsmasq dhcp boot (PXE) record for customizing network
# booting (--dhcp-boot).
#
# @param file
#
# @param tag
#
# @param hostname
#
# @param bootserver
#
define dnsmasq::dhcpboot (
  String $file,
  Optional[String] $tag        = undef,
  Optional[String] $hostname   = undef,
  Optional[String] $bootserver = undef,
) {
  $bootserver_real = $bootserver ? {
    undef   => '',
    default => ",${bootserver}",
  }
  $hostname_real = $hostname ? {
    undef   => '',
    default => ",${hostname}",
  }
  $tag_real = $tag ? {
    undef   => '',
    default => "tag:${tag},",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dhcpboot-${name}":
    order   => '03',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpboot.erb'),
  }
}
