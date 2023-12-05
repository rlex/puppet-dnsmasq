# Create an dnsmasq mx record (--mx-host).
#
# @param mx_name
#
# @param hostname
#
# @param preference
#
define dnsmasq::mx (
  # allow for duplicate "mx-host=<name>,..." entries
  String $mx_name              = $name,
  Optional[String] $hostname   = undef,
  Optional[String] $preference = undef,
) {
  include dnsmasq

  $hostname_real = $hostname ? {
    undef   => '',
    default => ",${hostname}",
  }

  $preference_real = $preference ? {
    undef   => '',
    default => ",${preference}",
  }

  concat::fragment { "dnsmasq-mx-${name}":
    # prevent "reordering" changes
    order   => "07_${mx_name}_${hostname_real}_${preference_real}",
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/mx.erb'),
  }
}
