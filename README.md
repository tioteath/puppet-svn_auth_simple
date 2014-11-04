# svn_auth_simple

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What svn_auth_simple affects](#what-svn_auth_simple-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with svn_auth_simple](#beginning-with-svn_auth_simple)
4. [Usage](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The `svn_auth_simple` module lets you manage plain text credentials in 
[Subversion Client Credentials Cache](http://svnbook.red-bean.com/en/1.7/svn.serverconfig.netmodel.html#svn.serverconfig.netmodel.credcache). 
Basically, it is intended to manage the content of `~/.subversion/auth/svn.simple` directory.

## Module Description

The module introduces the resource `svn_auth_simple`, which is used to manage repository credentials in user's home directory.  

## Setup

### What svn_auth_simple affects

* `~/.subversion/auth/svn.simple/*`

### Setup Requirements

`svn_auth_simple` uses Ruby-based providers, so you must have `pluginsync` enabled.

### Beginning with svn_auth_simple

To begin, you need to define resource `svn_auth_simple` with a set of 
subversion specific parameters.

```
svn_auth_simple { 'credentials for github repo':
  owner       => 'tio',
  group       => 'tio',
  home        => '/home/tio',
  uri         => 'https://github.com/tioteath/puppet-svn_auth_simple',
  username    => 'tioteath',
  password    => '__password__',
}
```

## Usage

In order to keep credentials cache valid, the request to remote repository is  required, so it can dramatically slow down catalog appliance, in case it manages a lot of svn_auth_simple resources for the same node.

## Reference


Defined Types:

* [svn_auth_simple](#type-svn_auth_simple)

Functions:

* [svn_realm_string_digest](#svn_realm_string_digest)


## Limitations

* The module currently can only manage plain-text credentials.
* Only http/https URI schemes are supported.
* Puppet master must have network access to Subversion server.
