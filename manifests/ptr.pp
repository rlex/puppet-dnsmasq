# Create an dnsmasq ptr record (--ptr-record).
#
# @param value
#
define dnsmasq::ptr (
  String $value,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-ptr-${name}":
    order   => '09',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/ptr.erb'),
  }
}
