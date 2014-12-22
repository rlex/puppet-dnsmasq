# Create an dnsmasq ptr record.
define dnsmasq::ptr (
  $hostname,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-ptr-${name}":
    order   => '09',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/ptr.erb'),
  }

}
