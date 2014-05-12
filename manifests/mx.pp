# Create an dnsmasq mx record
define dnsmasq::mx (
  # allow for duplicate "mx-host=<name>,..." entries
  $mx_name = $name,
  $hostname = undef,
  $preference = undef,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  $use_hostname = $hostname ? {
    undef   => '',
    default => ",${hostname}",
  }

  $use_preference = $preference ? {
    undef   => '',
    default => ",${preference}",
  }

  concat::fragment { "dnsmasq-mx-${name}":
    # prevent "reordering" changes
    order   => "07_${mx_name}_${use_hostname}_${$use_preference}",
    target  => $dnsmasq_conffile,
    content => template('dnsmasq/mx.erb'),
  }

}
