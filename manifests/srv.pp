# Create an dnsmasq srv record.
define dnsmasq::srv (
  $hostname,
  $port,
  $priority = undef,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-srv-${name}":
    order   => '08',
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/srv.erb'),
  }

}
