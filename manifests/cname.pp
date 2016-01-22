# Create an dnsmasq cname record (--cname).
define dnsmasq::cname (
  $hostname,
) {
  validate_slength($name,255)     # hostnames cannot be longer
  validate_slength($hostname,255) # hostnames cannot be longer

  include dnsmasq

  concat::fragment { "dnsmasq-cname-${name}":
    order   => '12',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/cname.erb'),
  }

}
