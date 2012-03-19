X_types
-------

A module that extends Puppet functionality on Mac OS X using custom types and 
providers.

### Version: 0.0.1

### Requirements:

* Minumum OS: Mac OS X 10.5.8
* RubyCocoa 1.0.2 or greater if using Mac OS X Lion 
 * Mac OS X Lion's RubyCocoa contains a bug that will segfault under certain conditions (http://tinyurl.com/7l3c34w)
* You can do something like this to get it installed... 
<code>
    case $::macosx\_productversion\_major {
      "10.7": {
        package { "RubyCocoa-1.0.2-OSX10.7.dmg":
          provider => 'pkgdmg',
          ensure => 'present',
          source  => 'http://iweb.dl.sourceforge.net/project/rubycocoa/RubyCocoa/1.0.2/RubyCocoa-1.0.2-OSX10.7.dmg',
          alias => 'rubycocoa',
        } #package
        exec { '/sbin/reboot':
          subscribe => Package['rubycocoa'],
          refreshonly => true,
        } #exec
      } #10.7
    } #case
</code>

### Notes:

At first glance, this module may appear to duplicate previous Puppet
functionality (it does), but it is worth noting that X_types has the ability 
to create and manage resources in arbitrary dslocal nodes. It also adds some
new functionality specific to Mac OS X.

### Examples:

#### Core Funtionality:

Include the x\_types module
<code>
  include x\_types
</code>

Create a new dslocal node
<code>
  x\_node { 'MCX':
    active => 'true',
    provider => 'dslocal',
    ensure => 'present'
  }
</code>

Create a new computer in the designated node
<code>
  x\_computer { "$::hostname":
    dslocal_node  => 'MCX',
    en_address    => "$::macaddress_en0",
    hardware_uuid => "$::sp_platform_uuid",
    ensure        => 'present',
    require       => X\_node['MCX']
  }
</code>

Create a new computer group and add the new computer record to it
<code>
  x\_computergroup { 'SomePolicyGroup':
    dslocal_node  => 'MCX',
    members       =>["$::hostname"],
    gid           => '5000',
    ensure        => 'present',
    require       => X\_computer["$::hostname"]
  }
</code>

Import MCX policy on the target computer group
<code>
  x\_policy { 'SomePolicyGroup':
    dslocal_node  => 'MCX',
    provider      => 'x\_mcx',
    type          => 'computergroup',
    plist         => '/private/etc/policy/mcx/managedmac.plist',
    ensure        => 'present',
  }
</code>

#### Special Providers:

Enable Apple Remote Desktop
<code>
  x\_remotemanagement { 'ard\_setup':
    users     => { 'ardop' => '-1073741569' },
    dirgroups => 'ardadmin, ardinteract, ardmanage, ardreports',
    dirlogins => 'enable',
    menuextra => 'disable',
    ensure    => 'running',
  }
</code>

Bind to an Active Directory
<code>
  # Unless we have an authoritative hostname, abort bind operation
  if "$::fqdn" == "$::certname" {
    x\_node { 'some.domain':
      active        => 'true',
      ensure        => 'present'
      provider      => 'activedirectory',
      active        => 'true',
      computerid    => 'some\_machine',
      username      => 'some_user',
      password      => 'a\_password',
      ou            => 'CN=Computers',
      domain        => 'some.domain',
      mobile        => 'disable',
      mobileconfirm => 'disable',
      localhome     => 'disable',
      useuncpath    => 'enable',
      protocol      => 'afp',
      shell         => '/bin/false',
      groups        => 'SOME\_DOMAIN\some\_group,SOME\_DOMAIN\another\_group',
      passinterval  => '0',     
    }
  } else {
    $msg = "Our FQDN ($::fqdn) does not match our certname ($::certname). Aborting Puppet run..."
    notice($msg)
    notify { $msg: }
  }
</code>

Enable ipfw and apply a set of rules
<code>
  # Rules read from a text file in the following form
  # rule\_no action proto from range to range
  # Example: 12308 allow ip from 192.168.0.0/16 to any
  firewall { 'ipfw\_setup':
    type      => ipfw,
    verbosity => '2',
    file      => '/private/etc/ipfw/ipfw_rules',
    require   => File['/private/etc/ipfw'],
  }
</code>