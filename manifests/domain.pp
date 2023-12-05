# Create a dnsmasq domain (--domain).
#
# @param subnet
#
# @param local
#
define dnsmasq::domain (
  Optional[String] $subnet = undef,
  Boolean $local           = false,
) {
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
