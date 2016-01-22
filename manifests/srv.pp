# Create an dnsmasq srv record (--srv-host).
define dnsmasq::srv (
  $hostname,
  $port,
  $priority = undef,
) {
  validate_re($port,'^[0-9]+$')
  if undef != $priority { validate_re($port,'^[0-9]+$') }

  $priority_real = $priority ? {
    undef   => '',
    default => ",${priority}",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-srv-${name}":
    order   => '09',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/srv.erb'),
  }

}
