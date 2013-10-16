# Create an dnsmasq mx record
define dnsmasq::mx (
  $hostname,
  $preference,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-mx-${name}":
    order   => '07',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/mx.erb'),
  }

}
