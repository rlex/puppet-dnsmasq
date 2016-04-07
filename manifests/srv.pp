# Create an dnsmasq srv record (--srv-host).
define dnsmasq::srv (
  $record = undef,
  $hostname,
  $port,
  $priority = undef,
  $weigth = undef,
) {
  validate_re($port,'^[0-9]+$')
  if undef != $priority { validate_re($port,'^[0-9]+$') }

  $record_real = $record ? {
    undef   => "${name}",
    default => "${record}",
  }

  $priority_real = $priority ? {
    undef   => ',0',
    default => "${priority}",
  }

  $weight_real = $weight ? {
    undef   => ',0',
    default => "${weigth}",
  }

  include dnsmasq

  concat::fragment { "dnsmasq-srv-${name}":
    order   => '09',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/srv.erb'),
  }

}
