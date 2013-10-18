# Create an dnsmasq ptr record.
define dnsmasq::ptr (
  $value,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-ptr-${name}":
    order   => '09',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/ptr.erb'),
  }

}
