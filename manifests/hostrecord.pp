# Create a dnsmasq A,AAAA and PTR record.
define dnsmasq::hostrecord (
  $ip,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-hostrecord-${name}":
    order   => '06',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/hostrecord.erb'),
  }

}
