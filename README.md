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
* Support for dnsmasq tagging system
* And much more

### DEPENDENCIES

* puppet >= 2.6
* puppetlabs/concat >= 1.0.0
* puppetlabs/stdlib

### BUILD STATUS
[![Build Status](https://travis-ci.org/rlex/puppet-dnsmasq.svg?branch=master)](https://travis-ci.org/rlex/puppet-dnsmasq)

### Basic class

Will install dnsmasq to act as DNS and TFTP (if specified) server

Example basic class config. Please refer to table below to see all possible variables

```puppet
class { 'dnsmasq':
  interface         => 'lo',
  listen_address    => '192.168.39.1',
  no_dhcp_interface => '192.168.49.1',
  domain            => 'int.lan',
  port              => '53',
  expand_hosts      => true,
  enable_tftp       => true,
  tftp_root         => '/var/lib/tftpboot',
  dhcp_boot         => 'pxelinux.0',
  dns_forward_max   => 1500,
  domain_needed     => true,
  bogus_priv        => true,
  no_negcache       => true,
  no_hosts          => true,
  resolv_file       => '/etc/resolv.conf',
  cache_size        => 1000,
  restart           => true,
}
```

Please refer to [dnsmasq man page](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html) to get exact syntax and options

Core variables:

Variable      | Type          | Default | Description
------------- | ------------- | ------------ | -----------
$auth_sec_servers | string | undef | sec servers
$auth_server | string  | undef | Enable auth server mode
$auth_ttl | string | undef | Override TTL value of auth server
$auth_zone | string | undef | DNS zone for auth mode
$bogus_priv | boolean | true | Bogus private reverse lookups
$cache_size | boolean | 1000 | Size of dns cache
$config_hash | array | undef | puppet config hash
$dhcp_boot | bool | true | Enable tftp booting
$dhcp_leasefile | boolean | true | DHCP leases file location
$dhcp_no_override | boolean | false | Disable re-use of the DHCP servername
$domain | string | undef | Network domain
$domain_needed | boolean | false | Do not forward A/AAAA without domain part
$dns_forward_max | string | undef | maximum number of concurrent DNS queries
$enable_tftp | boolean | undef | TFTP boot support
$expand_hosts | bool | true | Add the domain to simple names
$interface | string/array | undef | Listening interface
$listen_address | string | undef | Listening IP address
$local_ttl | string | undef | Local time to live
$max_ttl | string | undef | Maximum time to live
$max_cache_ttl | string | undef | Maximum TTL for entries in cache
$neg_ttl | string | undef | Negative cache timeout
$no_dhcp_interface | string/array | undef | Do not use DHCP on interface
$no_hosts | boolean | false | Ignore /etc/hosts file
$no_negcache | boolean | false | Do not cache negative responses
$no_resolv | boolean | false | Ignore resolv.conf file
$port | string | 53 | Listening port
$read_ethers | boolean | false | Read /etc/ethers for information about hosts
$reload_resolvconf | boolean | true | Update resolvconf on changes
$resolv_file | boolean | false | Location of resolv.conf file
$restart | boolean | true | Restart on config change
$run_as_user | string | undef | force dnsmasq under specific user
$save_config_file | boolean | true | Backup original config file
$service_enable | boolean | true | Start dnsmasq at boot
$service_ensure | string | running | Ensure service state
$strict_order | boolean | true | Use DNS servers order of resolv.conf
$tftp_root | string | /var/lib/tftpboot | Location of tftp boot files


There is also optional variables to override system-provided paths and names:

Variable      | Type          | Desc
------------- | ------------- | --------
$dnsmasq_confdir | string | Configuration directory location
$dnsmasq_conffile | string | Configuration file location
$dnsmasq_hasstatus | string | init.d status support
$dnsmasq_logdir | string | dnsmasq log directory
$dnsmasq_package | string | dnsmasq package name
$dnsmasq_package_provider | string | package system provider
$dnsmasq_service | string | Name of init.d service

### DHCP server configuration

Will add DHCP support to dnsmasq.
This can be used multiple times to setup multiple DHCP servers.
Parameter "set" is optional, this one makes use of tagging system in dnsmasq

```puppet
dnsmasq::dhcp { 'dhcp':
  set        => 'hadoop0' #optional
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
  mac => 'DE:AD:BE:EF:CA:FE',
  ip  => '192.168.1.10',
}
```

### Host record configuration

Will add static A, AAAA (if provided) and PTR record

```puppet
dnsmasq::hostrecord { "example-host-dns,example-host-dns.int.lan":
  ip   => '192.168.1.20',
  ipv6 => 'FE80:0000:0000:0000:0202:B3FF:FE1E:8329' #optional
}
```

### A record configuration

Will add static A record, this record will always override upstream data

```puppet
dnsmasq::address { "example-host-dns.int.lan":
  ip  => '192.168.1.20',
}
```

### CNAME records
Will add canonical name record.
Please note that dnsmasq cname is NOT regular cname and can be only for targets
which are names from DHCP leases or /etc/hosts, so it's more like alias for hostname

```puppet
dnsmasq::cname { "mail":
  hostname => "post"
}
```

### SRV records
Will add srv record which always overrides upstream data.
Priority argument is optional.

```puppet
dnsmasq::srv { "_ldap._tcp.example.com":
  hostname => "ldap-server.example.com",
  port     => "389",
  priority => "1",
}
```

### MX records
Will create MX (mail eXchange) record which always override upstream data

```puppet
dnsmasq::mx { "maildomain.com":
  hostname   => "mailserver.com",
  preference => "50",
}
```

### PTR records
Allows you to create PTR records for rDNS and DNS-SD.

```puppet
dnsmasq::ptr { "_http._tcp.dns-sd-services":
  value => '"New Employee Page._http._tcp.dns-sd-services"'
}
```

### TXT records
Allows you to create TXT records

```puppet
dnsmasq::txt { "_http._tcp.example.com":
  value => "name=value,paper=A4"
}
```
(this actually should be done via array, will fix later)

### DHCP option configuration

Will add dhcp option. Can be used for all types of options, ie:

* numeric ( option => '53' )
* ipv4-option ( option => 'option:router' )
* ipv6-option ( option => 'option6:dns-server' )

Can be used multiple times.

```puppet
dnsmasq::dhcpoption { 'my-awesome-dhcp-option':
  option  => 'option:router'
  content => '192.168.1.1',
  tag     => 'sometag', #optional
}
```

### DHCP booting (PXE)

Allows you to setup different PXE servers in different subnets.
tag is optional, you can use this to specify subnet for bootserver,
using tag you previously specified in dnsmasq::dhcp
Can be used multiple times.

```puppet
dnsmasq::dhcpboot { 'hadoop-pxe':
  tag        => 'hadoop0', #optional
  file       => 'pxelinux.0',
  hostname   => 'newoffice', #optional
  bootserver => '192.168.39.1' #optional
}
```

### Per-subnet domain

Allows you to specify different domain for specific subnets.
Can be used multiple times.

```puppet
dnsmasq::domain { 'guests.company.lan':
  subnet => '192.168.196.0/24',
}
```

### DNS server
Configure the DNS server to query external DNS servers
```puppet
dnsmasq::dnsserver { 'dns':
  ip => '192.168.1.1',
}
```

Or, to query specific zone
```puppet
dnsmasq::dnsserver { 'forward-zone':
  domain => "dumb.domain.tld",
  ip => "192.168.39.1",
  port => '9001', #optional
}
```

### DNS-RR records
Allows dnsmasq to serve arbitrary records, for example:
```puppet
dnsmasq::dnsrr { 'example-sshfp':
    domain => 'example.com',
    type   => '44',
    rdata  => '2:1:123456789abcdef67890123456789abcdef67890'
}
```

### Running in Docker containers
When running in a Docker container, dnsmasq tries to drop root privileges. This causes the following error:
```
dnsmasq: setting capabilities failed: Operation not permitted
```

In this case you can use the run\_as\_user to provide the appropriate user to run as:
```puppet
class { 'dnsmasq':
  interface         => 'lo',
  listen_address    => '192.168.39.1',
  no_dhcp_interface => '192.168.49.1',
  ....
  run_as_user       => 'root',
}
```
