# Create an dnsmasq domains.
define dnsmasq::domain (
  $subnet = undef,
  $local  = false,
) {
  validate_bool($local)
  include dnsmasq

  $local_real = $local ? {
    true  => ',local',
    false => '',
  }
  $subnet_real = $subnet ? {
    undef   => '',
    default => ",${subnet}",
  }

  concat::fragment { "dnsmasq-domain-${name}":
    order   => '05',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/domain.erb'),
  }

}
