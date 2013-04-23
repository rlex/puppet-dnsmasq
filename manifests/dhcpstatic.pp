# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcpstatic (
  $mac,
  $macip,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-staticdhcp-${name}":
    order   => '02',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/staticdhcp.erb'),
  }

}
