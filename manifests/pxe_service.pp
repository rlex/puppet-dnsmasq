# Create a dnsmasq pxe-service
define dnsmasq::pxe_service (
  $content,
  $paramtag = undef,
) {
  include dnsmasq::params

  $dnsmasq_conffile = $dnsmasq::params::dnsmasq_conffile

  concat::fragment { "dnsmasq-pxe_service-${name}":
    order   => '02',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/pxe_service.erb'),
  }
}
