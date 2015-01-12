# Create an dnsmasq dnsrr record (--dns-rr).
define dnsmasq::dnsrr (
  $domain,
  $type,
  $rdata,
) {
  validate_re($type,'^[a-fA-F0-9]+$')

  # Remove spaces or colons from rdata for consistency.
  $rdata_real = downcase(regsubst($rdata,'[ :]','','G'))
  validate_re($rdata_real,'^[a-f0-9]+$')

  include dnsmasq

  concat::fragment { "dnsmasq-dnsrr-${name}":
    order   => '11',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsrr.erb'),
  }

}
