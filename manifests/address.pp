# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::address (
  $ip,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-staticdns-${name}":
    order   => '03',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/address.erb'),
  }

}
