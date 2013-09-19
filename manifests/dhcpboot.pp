# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcpboot (
  $tag = undef,
  $file,
  $name,
  $address,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dhcpboot-${name}":
    order   => '02',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dhcpboot.erb'),
  }

}
