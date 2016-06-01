# rdiff_backup

[![Build Status](https://travis-ci.org/jordanconway/puppet-rdiff_backup.png)](https://travis-ci.org/jordanconway/puppet-rdiff_backup)

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

### Setup Requirements

This module requires puppetdb and storedconfigs to propperly work.
Dependancy modules are
 * puppetlabs-stdlib >= 1.0.0
 * jtopjian-sshkeys >= 2.1.0
 * dalen-puppetdbquery >= 1.3.2

### Beginning with rdiff_backup

#### Minimum viable configuration
**Parameters that exist on the server and client must be identical.** The defaults
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
Technically *$rdiff_server* will default to  *"backup.${::domain}"* but it's safer
to specify it yourself since your infrastructure may not match that configuration.

## Usage

With clients and servers defined you'll want to start backing things up.
This is done using the *rdiff_backup::rdiff_export* type.
Example:
```
rdiff_backup::rdiff_export {'webserver-etc':
  ensure          => present,
  path            => '/etc',
  rdiff_retention => '2D',
  cron_hour       => '3',
  rdiffbackuptag  => 'production-YUL'
}
```
#### A note about rdiff_retention
The time interval is an integer followed by the
 character s, m, h, D, W, M, or Y, indicating  seconds, minutes, hours, days,
 weeks, months, or years respectively, or a number of these concatenated. For
 example, 32m  means  32  minutes, and 3W2D10h7s means 3 weeks, 2 days, 10
 hours, and 7 seconds. In this context, a month means 30 days, a year is
 365 days, and a day is always 86400 seconds.

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
}
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
    cron_hour: '2'
  export4:
    path: '/etc/export4'
    rdiff_retention: '5D'
    cron_hour: '3'
```
## Reference

###Classes
* rdiff_backup: Install and configure an rdiff-backup server.
* rdiff_backup::server::user: Sets up the rdiff backup user on the server. (Accessed via rdiff_backup:)
* rdiff_backup::server::install: Installs rdiff-backup on the server. (Accessed via rdiff_backup:)
* rdiff_backup::server::import: Imports exported configs from the clients. (Accessed via rdiff_backup:)
* rdiff_backup::client: Install and configure and rdiff-backup client.
* rdiff_backup::client::install: Install rdiff-backup on the client. (Accessed via rdiff_backup::client:)

###Defines
* `rdiff_backup::rdiff_export`: Exports the backup configuration to the defined server and sets up a local cronjob to run the backup script.

###Parameters

####Class: `rdiff_backup`
#####`rdiffbackuptag`
The tag that controls which clients and defined rdiff_exports  will be collected by the server. Type String, Default: see $rdiff_backup::params::rdiffbackuptag

#####`rdiff_user`
The user that runs rdiffbackup on the server. Type: String, Default value: see $rdiff_backup::params::rdiff_user

#####`remote_path`
The path on the server where backups will live, if using nfs or other remote/mounted filesystem configure it first. Type String(absolute_path), Default value: $rdiff_backup::params::remote_path,

####`package`
Module is currently CentOS/RHEL specific right now, if you use a custom package for rdiff-backup, specify it here. Type String, Default value: $rdiff_backup::params::package

####Class: `rdiff_backup::client`
#####`rdiffbackuptag`
The tag that controls which clients and defined rdiff_exports  will be collected by the server. Type String, Default: see $rdiff_backup::params::rdiffbackuptag

#####`rdiff_user`
The user that runs rdiffbackup on the server. Type: String, Default value: see $rdiff_backup::params::rdiff_user

#####`remote_path`
The path on the server where backups will live, if using nfs or other remote/mounted filesystem configure it first. Type String(absolute_path), Default value: $rdiff_backup::params::remote_path,

####`package`
Module is currently CentOS/RHEL specific right now, if you use a custom package for rdiff-backup, specify it here. Type String, Default value: $rdiff_backup::params::package

####Define: `rdiff_backup::rdiff_export`
The default params that come from $::rdiff_backup::client should not be changed unless you are certain what you are doing and make sure they match existing client/server values.
Unless Specified these parameters are optional.

#####`ensure`
This will ensure wether or not the cron definition that runs the backup script and the backup script exists on the client machine. Type: String, Valid Options: 'present' and 'absent' Default value: 'present'

#####`path`
REQUIRED. The path of the directory or files that you are backing up with this define. Type: String(absolute_path), Default value: undef

#####`rdiff_retention`
*See [A note about rdiff_retention](#a-note-about-rdiff_retention) Type: String, Default value: '1D'

#####`rdiff_user`
The user that runs rdiffbackup on the server - this should not be changed. Type: String, Default value: $::rdiff_backup::client::rdiff_user

#####`remote_path`
The remote path on the rdiff server where backups will live - this should not be changed. Type String(absolute_path), Default value: $::rdiff_backup::client::remote_path

#####`rdiff_server`
The rdiff-backup server that the backup will be sent to - this should not be changed. Type String, Default value: $::rdiff_backup::client::rdiff_server

#####`rdiffbackuptag`
The tag that controls which server will collect the backup. Unless you are sending multiple files on the same client to different servers this should not be changed. Type String, Default: $::rdiff_backup::client::rdiffbackuptag

#####`cron_hour`
The hour at which the cron job runs. Type String (as an Int value between 0-23), Default value: 1

#####`cron_minute`
The minute at which the cron job runs. Type String (as an Int value between 0-59) Default value: undef

#####`cron_jitter`
An optional value that will add a random jitter into the rdiff-backup commands. This can help avoid all machines sending their backups at the exact same time, even within the same cron_hour/minute and help reduce overall load, especially on virtualized systems sharing the same host. It is the maximum number of seconds of random wait before executing the command. Type Integer(non-zero, positive), Default: 1

######Example:
```
rdiff_backup::rdiff_export {'myexport':
  ensure          => # Type: String, Default: present
  path            => # REQUIRED, Type: String, Default: undef
  rdiff_retention => # Type: String*, Default: '1D'
  rdiff_user      => # Type: String, Default: $::rdiff_backup::client::rdiff_user
  remote_path     => # Type String(absolute_path), Default: $::rdiff_backup::client::remote_path
  rdiff_server    => # Type String, Default: $::rdiff_backup::client::rdiff_server
  rdiffbackuptag  => # Type String, Default: $::rdiff_backup::client::rdiffbackuptag
}
```
## Limitations

CentOS/RHEL 7 only thus far. May also work on EL6.

## Development

PRs Welcome!

## Release Notes/Contributors/Etc.

PRE-RELEASE
