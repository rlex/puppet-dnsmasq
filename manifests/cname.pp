# Create an dnsmasq cname record
define dnsmasq::cname (
  $hostname,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-cname-${name}":
    order   => '10',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/cname.erb'),
  }

}
