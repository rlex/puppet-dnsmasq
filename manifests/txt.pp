# Create an dnsmasq txt record.
define dnsmasq::txt (
  $value,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-txt-${name}":
    order   => '10',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/txt.erb'),
  }

}
