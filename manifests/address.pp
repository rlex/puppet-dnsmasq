# Create a dnsmasq A record (--address).
#
# @param ip
#
define dnsmasq::address (
  String $ip,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-staticdns-${name}":
    order   => "06_${name}",
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/address.erb'),
  }
}
