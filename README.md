### DESCRIPTION

I wrote this module in need of managing bunch of servers running dnsmasq. 

It features some advanced features like:

* Basic dnsmasq management (service, installation)
* Cross-os support (tested on rpm- and deb-based distros. Should also support freebsd)
* Loads of options in basic config (ie TFTP) If you need any additional option that does not supported in this module, just ping me
* Support for DHCP configuration.
* Support for adding static DHCP records (MAC -> IP binding)
* Support for adding static DNS records (IP -> hostname binding)
* Support for DHCP options

### TODO

* Rewrite OS detection based on $::OSFamily

### Basic class
(All possible options shown here)

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

```puppet
dnsmasq::dhcp { 'dhcp': 
  dhcp_start => '192.168.1.100',
  dhcp_end   => '192.168.1.200',
  lease_time => '24h'
}
```

### Static DHCP record configuration
(Please be aware that example-host will also be used as DNS name)

```puppet
dnsmasq::staticdhcp { 'example-host':
  mac  => 'DE:AD:BE:EF:CA:FE',
  macip => '192.168.1.10',
}
```
### Static DNS record configuration

```puppet
dnsmasq::address { "example-host-dns.int.lan":
  ip  => '192.168.1.20',
}
```

### DHCP option configuration 

```puppet
dnsmasq::dhcpoption { 'option:router':
  content => '192.168.1.1',
}
```
