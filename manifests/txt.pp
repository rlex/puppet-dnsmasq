# Create an dnsmasq txt record (--txt-record).
#
# @param value
#
define dnsmasq::txt (
  String $value,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-txt-${name}":
    order   => '10',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/txt.erb'),
  }
}
