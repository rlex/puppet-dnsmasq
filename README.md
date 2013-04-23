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
* puppetlabs/stdlib >= 2.0.0

### TODO

* Rewrite OS detection based on $::OSFamily

### Basic class

Will install dnsmasq to act as DNS and TFTP (if specified) server

All possible options shown here

```puppet
class { 'dnsmasq':
  interface     => 'lo',
  domain        => 'int.lan',
  port          => '53',
  expand_hosts  => true,
  enable_tftp   => true,
  tftp_root     => '/var/lib/tftpboot',
  dhcp_boot     => 'pxelinux.0',
  domain_needed => true,
  bogus_priv    => true,
  no_negcache   => true,
}
```

### DHCP server configuration

Will add DHCP support to dnsmasq.

```puppet
dnsmasq::dhcp { 'dhcp': 
  dhcp_start => '192.168.1.100',
  dhcp_end   => '192.168.1.200',
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

```puppet
dnsmasq::dhcpoption { 'option:router':
  content => '192.168.1.1',
}
```
