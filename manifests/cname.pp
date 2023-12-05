# Create an dnsmasq cname record (--cname).
#
# @param hostname
#
define dnsmasq::cname (
  String $hostname,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-cname-${name}":
    order   => '11',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/cname.erb'),
  }
}
