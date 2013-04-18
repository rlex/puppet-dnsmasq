class {
  'dnsmasq':
  $interface = 'eth0',
  $domain = 'int.lan',
  $expand_hosts = true,
  $enable_tftp = false,
  $tftp_root = '/var/lib/tftpboot',
  $dhcp_boot = 'pxelinux.0',
  $domain_needed = true,
  $bogus_priv = true, 
}

dnsmasq::dhcp { 'dhcp': 
  dhcp_start => '192.168.1.100',
  dhcp_end   => '192.168.1.200',
  lease_time => '24h'
}

dnsmasq::staticdhcp { 'example_host':
  mac  => 'DE:AD:BE:EF:CA:FE',
  macip => '192.168.1.10',
}

dnsmasq::staticdns { "example_host_dns":
  address  => '192.168.1.20',
}

