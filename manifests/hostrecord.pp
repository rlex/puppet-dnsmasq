# Create a dnsmasq A,AAAA and PTR record.
define dnsmasq::hostrecord (
  $ip,
) {
  if $ip =~ /\./ { validate_re($ip,'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$') }

  include dnsmasq

  concat::fragment { "dnsmasq-hostrecord-${name}":
    order   => '06',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/hostrecord.erb'),
  }

}
