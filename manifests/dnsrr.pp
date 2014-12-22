# Create an dnsmasq dnsrr record.
define dnsmasq::dnsrr (
  $domain,
  $type,
  $rdata
) {
  validate_re($type,'^\w+$')

  # Remove spaces or colons from rdata for consistency.
  $rdata_real = regsubst($rdata,'[ :]','','G')
  validate_re($rdata_real,'^\h+$')

  include dnsmasq

  concat::fragment { "dnsmasq-dnsrr-${name}":
    order   => '11',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsrr.erb'),
  }

}
