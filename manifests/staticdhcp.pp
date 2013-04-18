# Create an dnsmasq stub zone for caching upstream name resolvers.
define dnsmasq::staticdhcp (
  $mac,
  $macip,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-staticdhcp-$staticip":
    order   => '02',
    target  => "${dnsmasq_conffile}",
    content => template("dnsmasq/staticdhcp.erb"),
  }

}
