# Create an dnsmasq dhcp boot (PXE) record for customizing network
# booting (--dhcp-boot).
define dnsmasq::dhcpboot (
  $file,
  $paramtag   = undef,
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
  $paramtag_real = $paramtag ? {
    undef   => '',
    default => "tag:${paramtag},",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-dhcpboot-${name}":
    order   => '03',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpboot.erb'),
  }

}
