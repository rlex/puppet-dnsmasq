# Create an dnsmasq A record.
define dnsmasq::address (
  $ip,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-staticdns-${name}":
    order   => '06',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/address.erb'),
  }

}
