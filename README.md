### DESCRIPTION

I wrote this module in need of managing bunch of servers running dnsmasq. 

It features some advanced features like:

* Basic dnsmasq management (service, installation)
* Cross-OS support (Debian, Ubuntu, RHEL, FreeBSD)
* Loads of options in basic config (ie TFTP)
(If you need any additional option that does not supported in this module, just ping me)
* Support for DHCP configuration.
* Support for adding static DHCP records (MAC -> IP binding)
* Support for adding static DNS records (IP -> hostname binding)
* Support for DHCP options

### DEPENDENCIES

* puppet >= 2.6
* puppetlabs/concat >= 1.0.0

### TODO

* Rewrite OS detection based on $::OSFamily

### Basic class

Will install dnsmasq to act as DNS and TFTP (if specified) server

All possible options shown here

```puppet
class { 'dnsmasq':
  interface      => 'lo',
  listen_address => '192.168.39.1',
  domain         => 'int.lan',
  port           => '53',
  expand_hosts   => true,
  enable_tftp    => true,
  tftp_root      => '/var/lib/tftpboot',
  dhcp_boot      => 'pxelinux.0',
  domain_needed  => true,
  bogus_priv     => true,
  no_negcache    => true,
  no_hosts       => true,
  resolv_file    => '/etc/resolv.conf',
  cache_size     => 1000
}
```

### DHCP server configuration

Will add DHCP support to dnsmasq.
This can be used multiple times to setup multiple DHCP servers.
Parameter "paramset" is optional, this one makes use of tagging system in dnsmasq

```puppet
dnsmasq::dhcp { 'dhcp': 
  paramset   => 'hadoop0'
  dhcp_start => '192.168.1.100',
  dhcp_end   => '192.168.1.200',
  netmask    => '255.255.255.0',
  lease_time => '24h'
}
```

### Static DHCP record configuration

Will add static DHCP record to DHCP server with hostname.
Please be aware that example-host will also be used as DNS name.

```puppet
dnsmasq::dhcpstatic { 'example-host':
  mac  => 'DE:AD:BE:EF:CA:FE',
  ip => '192.168.1.10',
}
```

### Static DNS record configuration

Will add static A record, this record will always override upstream data

```puppet
dnsmasq::address { "example-host-dns.int.lan":
  ip  => '192.168.1.20',
}
```

### DHCP option configuration

Will add dhcp option. Can be used for all types of options, ie:

* numeric ( dnsmasq::dhcpoption { '53': ... }
* ipv4-option ( dnsmasq::dhcpoption { 'option:router': ... }
* ipv6-option ( dnsmasq::dhcpoption { 'option6:dns-server': ... }

Can be used multiple times.

```puppet
dnsmasq::dhcpoption { 'option:router':
  content => '192.168.1.1',
}
```

### DHCP booting (PXE)

Allows you to setup different PXE servers in different subnets.
paramtag is optional, you can use this to specify subnet for bootserver, 
using tag you previously specified in dnsmasq::dhcp  
Can be used multiple times.

```
dnsmasq::dhcpboot { 'hadoop-pxe':
    paramtag   => 'hadoop0',
    file       => 'pxelinux.0',
    hostname   => 'newoffice',
    bootserver => '192.168.39.1'
}
```

### Per-subnet domain

Allows you to specify different domain for specific subnets.
Can be used multiple times.

```
dnsmasq::domain { 'guests.company.lan':
    subnet => '192.168.196.0/24',
}
```
