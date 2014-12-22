# Create an dnsmasq srv record.
define dnsmasq::srv (
  $hostname,
  $port,
  $priority = undef,
) {
  validate_re($port,'^\d+$')
  if undef != $priority { validate_re($port,'^\d+$') }

  $priority_real = $priority ? {
    undef   => '',
    default => ",${priority}",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-srv-${name}":
    order   => '08',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/srv.erb'),
  }

}
