# Primary class with options
class dnsmasq (
  $interface                = undef,
  $no_dhcp_interface        = undef,
  $listen_address           = undef,
  $domain                   = undef,
  $expand_hosts             = true,
  $port                     = '53',
  $enable_tftp              = false,
  $tftp_root                = '/var/lib/tftpboot',
  $dhcp_boot                = undef,
  $strict_order             = true,
  $domain_needed            = true,
  $bogus_priv               = true,
  $dhcp_no_override         = false,
  $no_negcache              = false,
  $no_hosts                 = false,
  $resolv_file              = false,
  $cache_size               = 1000,
  $config_hash              = {},
  $service_ensure           = 'running',
  $service_enable           = true,
  $auth_server              = undef,
  $auth_sec_servers         = undef,
  $auth_zone                = undef,
  $run_as_user              = undef,
  $restart                  = true,
  $reload_resolvconf        = true,
  $save_config_file         = true,
  $dnsmasq_package_provider = $dnsmasq::params::dnsmasq_package_provider,
  $dnsmasq_package          = $dnsmasq::params::dnsmasq_package,
  $dnsmasq_conffile         = $dnsmasq::params::dnsmasq_conffile,
  $dnsmasq_hasstatus        = $dnsmasq::params::dnsmasq_hasstatus,
  $dnsmasq_logdir           = $dnsmasq::params::dnsmasq_logdir,
  $dnsmasq_service          = $dnsmasq::params::dnsmasq_service,
  $dnsmasq_confdir          = $dnsmasq::params::dnsmasq_confdir,
) inherits dnsmasq::params {

  ## VALIDATION

  validate_bool(
    $bogus_priv,
    $dhcp_no_override,
    $domain_needed,
    $dnsmasq_hasstatus,
    $enable_tftp,
    $expand_hosts,
    $no_hosts,
    $no_negcache,
    $save_config_file,
    $service_enable,
    $strict_order,
    $reload_resolvconf,
    $resolv_file,
    $restart
  )
  validate_hash($config_hash)
  validate_re($service_ensure,'^(running|stopped)$')

  ## CLASS VARIABLES

  # Allow custom ::provider fact to override our provider, but only
  # if it is undef.
  $provider_real = empty($::provider) ? {
    true    => $dnsmasq_package_provider ? {
      undef   => $::provider,
      default => $dnsmasq_package_provider,
    },
    default => $dnsmasq_package_provider,
  }

  ## MANAGED RESOURCES

  concat { 'dnsmasq.conf':
    path    => $dnsmasq_conffile,
    require => Package['dnsmasq'],
  }

  concat::fragment { 'dnsmasq-header':
    order   => '00',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsmasq.conf.erb'),
  }

  package { 'dnsmasq':
    ensure   => installed,
    name     => $dnsmasq_package,
    provider => $provider_real,
    before   => Service['dnsmasq'],
  }

  service { 'dnsmasq':
    ensure    => $service_ensure,
    name      => $dnsmasq_service,
    enable    => $service_enable,
    hasstatus => $dnsmasq_hasstatus,
  }

  if $restart {
    Concat['dnsmasq.conf'] ~> Service['dnsmasq']
  }

  if $dnsmasq_confdir {
    file { $dnsmasq_confdir:
      ensure => 'directory',
      owner  => 0,
      group  => 0,
      mode   => '0755',
    }
  }

  if $save_config_file {
    # let's save the commented default config file after installation.
    exec { 'save_config_file':
      command => "cp ${dnsmasq_conffile} ${dnsmasq_conffile}.orig",
      creates => "${dnsmasq_conffile}.orig",
      path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin', ],
      require => Package['dnsmasq'],
      before  => Concat['dnsmasq.conf'],
    }
  }

  if $reload_resolvconf {
    exec { 'reload_resolvconf':
      provider => shell,
      command  => '/sbin/resolvconf -u',
      path     => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin', ],
      user     => root,
      onlyif   => 'test -f /sbin/resolvconf',
      before   => Service['dnsmasq'],
      require  => Package['dnsmasq'],
    }
  }

  if ! $no_hosts {
    Host <||> {
      notify +> Service['dnsmasq'],
    }
  }
}

