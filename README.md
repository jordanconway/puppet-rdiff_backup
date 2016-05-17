# rdiff_backup

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with rdiff_backup](#setup)
    * [What rdiff_backup affects](#what-rdiff_backup-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rdiff_backup](#beginning-with-rdiff_backup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

A module to install and configure rdiff-backup on a server and clients.
A defined type *rdiff_backup::rdiff_exports* added on clients will export
to servers and setup backups according to the configured option.
Currently CentOS/RHEL 7 only, requires puppetdb and storedconfigs.

## Setup

### What rdiff_backup affects

* *$package* will be installed on servers and clients.
* A ssh pubkey for root on each client will be created/exported to connect to
 the *$rdiff_user* on the server.
* *$rdiff_user* will be created on the server with a $HOME of '/var/lib/rdiff/'
 and the pubkey from root on each client will be added to
 '/var/lib/rdiff/.ssh/authorized_keys' file with limited commands to only run
 rdiff-backup related commands
* *$remote_path* will be created/managed on the server. If you plan on using NFS
 or other remote/mounted filesystems configure it before this module.
* On each client *$backup_script* will be created to manage the rdiff-backup
 commands

### Setup Requirements

This module requires puppetdb and storedconfigs to propperly work.
Dependancy modules are
 * puppetlabs-stdlib >= 1.0.0
 * jtopjian-sshkeys >= 2.1.0
 * dalen-puppetdbquery >= 1.3.2

### Beginning with rdiff_backup

#### Minimum viable configuration
Some of the server and client parameters need to be identical. The defaults
will be identical, but if you plan on changing any of them they need to be
identical for both rdiff_backup and rdiff_backup::client's parameters
##### Server Node
```
class { 'rdiff_backup':
}
```
This will use the defaults from rdiff_backup::params to configure a server with
  $package = 'rdiff-backup'
  $remote_path = '/srv/rdiff'
  $rdiffbackuptag = 'rdiffbackuptag'
  $rdiff_user = 'rdiffbackup'
##### Client Nodes
```
class { 'rdiff_backup::client':
  rdiff_server   => 'your.backup.fqdn',
}
```
This will use the defaults from rdiff_backup::params to configure a client with
  $package = 'rdiff-backup'
  $remote_path = '/srv/rdiff'
  $rdiffbackuptag = 'rdiffbackuptag'
  $rdiff_user = 'rdiffbackup'
  $backup_script = '/usr/local/bin/rdiff_backup.sh'
Technically *$rdiff_server* will default to  *"backup.${::domain}"* but it's safer
to specify it yourself since your infrastructure may not match that configuration.

## Usage

With clients and servers defined you'll want to start backing things up.
This is done using the *rdiff_backup::rdiff_export* type.
Example:
```
rdiff_backup::rdiff_export {'webserver-etc':
  ensure          => present,
  path            => '/etc,
  rdiff_retention => '2D',
  rdiffbackuptag  => 'production-YUL'
}
```
## The Hiera/Roles/Profiles way
###Example client profile
```
# Rdiff_backup client
class profile::rdiff_backup::client {
  include ::rdiff_backup::client

  $rdiff_exports = hiera('rdiff_backup::rdiff_exports', undef)
  if ( $rdiff_exports ) {
    create_resources('rdiff_backup::rdiff_export', $rdiff_exports)
  }

}
```
###Example server profile
```
#rdiff_backup::server profile
class profile::rdiff_backup::server {
  include ::rdiff_backup

  selinux::module {'mysshd':
    source => 'puppet:///modules/profile/rdiff_backup/selinux/mysshd.te',
  }

}
```
mysshd.te
```
module mysshd 1.0;

require {
  type sshd_t;
  type var_lib_t;
  class file read;
  class file open;
  class file getattr;
}

#============= sshd_t ==============
allow sshd_t var_lib_t:file read;
allow sshd_t var_lib_t:file open;
allow sshd_t var_lib_t:file getattr;
```
### Example hiera
common.yaml
```
rdiff_backup::rdiffbackuptag: 'production-YUL'
rdiff_backup::rdiff_user: 'backupman'
rdiff_backup::remote_path: '/srv/rdiffbackups'
rdiff_backup::client::rdiff_user: 'backupman'
rdiff_backup::client::rdiffbackuptag: 'production-YUL'
rdiff_backup::client::remote_path: '/srv/rdiffbackups'
rdiff_backup::client::rdiff_server: 'backups.businessfactory.tld'
```
client_x.yaml
```
rdiff_backup::rdiff_exports:
  export3:
    path: '/etc/export3'
    rdiff_retention: '2D'
  export4:
    path: '/etc/export4'
    rdiff_retention: '5D'
```
## Reference

### Defined type full options
Example:
```
rdiff_backup::rdiff_export {'myexport':
  ensure          => # Type: String, Default: present
  path            => # REQUIRED, Type: String, Default: undef
  rdiff_retention => # Type: String, Default: '1D'
  rdiff_user      => # Type: String, Default: $::rdiff_backup::client::rdiff_user
  remote_path     => # Type String(absolute_path), Default: $::rdiff_backup::client::remote_path
  rdiff_server    => # Type String, Default: $::rdiff_backup::client::rdiff_server
  rdiffbackuptag  => # Type String, Default: $::rdiff_backup::client::rdiffbackuptag
  backup_script   => #Type String, Default: ::rdiff_backup::client::backup_script
}
```
## Limitations

CentOS/RHEL 7 only thus far. May also work on EL6.

## Development

PRs Welcome!

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
