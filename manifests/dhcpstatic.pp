# Create an dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-host).
#
# @param mac
#
# @param ip
#
define dnsmasq::dhcpstatic (
  String $mac,
  String $ip,
) {
  $mac_real = downcase($mac)

  include dnsmasq

  concat::fragment { "dnsmasq-staticdhcp-${name}":
    order   => '04',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpstatic.erb'),
  }
}
