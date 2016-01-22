# Create an dnsmasq dhcp boot (PXE) record for customizing network
# booting (--dhcp-boot).
define dnsmasq::dhcpboot (
  $file,
  $tag   = undef,
  $hostname   = undef,
  $bootserver = undef,
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
    order   => '04',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpboot.erb'),
  }

}
