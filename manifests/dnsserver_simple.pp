# Defines a default DNS server to be used, _without_ name path.
define dnsmasq::dnsserver_simple {

  include dnsmasq::params

  validate_ipv4_address($name)

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-dnsserver-default-${name}":
    order   => '12',
    target  => $dnsmasq_conffile,
    content => "server=${name}\n",
  }
}
