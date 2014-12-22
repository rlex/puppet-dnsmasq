# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::dhcpstatic (
  $mac,
  $ip,
) {
  validate_re($mac,'^\h{2}:\h{2}:\h{2}:\h{2}:\h{2}:\h{2}$')
  if $ip =~ /\./ { validate_re($ip,'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$') }

  include dnsmasq

  concat::fragment { "dnsmasq-staticdhcp-${name}":
    order   => '04',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpstatic.erb'),
  }

}
