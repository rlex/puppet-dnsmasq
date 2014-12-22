# Create an dnsmasq A record.
define dnsmasq::address (
  $ip,
) {
  if $ip =~ /\./ { validate_re($ip,'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$') }

  include dnsmasq

  concat::fragment { "dnsmasq-staticdns-${name}":
    order   => "06_${name}",
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/address.erb'),
  }

}
