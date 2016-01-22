# Create a dnsmasq dhcp match
define dnsmasq::dhcpmatch (
  $content,
  $paramtag = undef,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dhcpmatch-${name}":
    order   => '01',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dhcpmatch.erb'),
  }
}
