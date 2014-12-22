# Create an dnsmasq cname record
define dnsmasq::cname (
  $hostname,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-cname-${name}":
    order   => '11',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/cname.erb'),
  }

}
