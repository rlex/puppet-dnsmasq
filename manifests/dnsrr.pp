# Create an dnsmasq dnsrr record.
define dnsmasq::dnsrr (
  $domain,
  $type,
  $rdata
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dnsrr-${name}":
    order   => '11',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dnsrr.erb'),
  }

}
