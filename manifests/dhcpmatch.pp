# Create a dnsmasq dhcp match
define dnsmasq::dhcpmatch (
  $content,
  $paramtag = undef,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dhcpmatch-${name}":
    order   => '02',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcpmatch.erb'),
  }
}
