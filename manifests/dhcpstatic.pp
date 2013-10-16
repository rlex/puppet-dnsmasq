# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcpstatic (
  $mac,
  $ip,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-staticdhcp-${name}":
    order   => '04',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dhcpstatic.erb'),
  }

}
