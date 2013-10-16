# Create an dnsmasq dhcp boot (PXE) record for customizing network booting
define dnsmasq::dhcpboot (
  $paramtag = undef,
  $file,
  $hostname,
  $bootserver,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dhcpboot-${name}":
    order   => '03',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dhcpboot.erb'),
  }

}
