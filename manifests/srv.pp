# Create an dnsmasq srv record (--srv-host).
#
# @param hostname
#
# @param port
#
# @param priority
#
define dnsmasq::srv (
  String $hostname,
  String $port,
  String $priority = undef,
) {
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
