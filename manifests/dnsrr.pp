# Create an dnsmasq dnsrr record (--dns-rr).
#
# @param domain
#
# @param type
#
# @param rdata
#
define dnsmasq::dnsrr (
  String $domain,
  String $type,
  String $rdata,
) {
  # Remove spaces or colons from rdata for consistency.
  $rdata_real = downcase(regsubst($rdata,'[ :]','','G'))

  include dnsmasq

  concat::fragment { "dnsmasq-dnsrr-${name}":
    order   => '11',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsrr.erb'),
  }
}
