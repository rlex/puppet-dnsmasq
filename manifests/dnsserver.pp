# Configure the DNS server to query sub domains to external DNS servers
define dnsmasq::dnsserver (
  $ip,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dnsserver-${name}":
    order   => '12',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/dnsserver.erb'),
  }
}
