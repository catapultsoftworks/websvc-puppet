#VARIABLES
$user = "vagrant"

# GLOBAL PATH SETTING
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# Add DNS entry.  On Vagrant this should use the host's DNS lookup; not sure why it failed when 
# it has worked before, but this fixes it.
file {'resolv.conf':
      path    => '/etc/resolv.conf',
      ensure  => present,
      mode    => 0644,
      content => "; generated by /sbin/dhclient-script\nnameserver 129.74.250.99\nnameserver 192.168.1.1"
    }


include openresty
include oracle_instant_client
include rvm
include install_things_with_rvm

# RVM module must exist and have had the libcurl dependency file modified to work
# on Amazon Linux (by changing the default to libcurl-devel in /manifests/dependencies/centos.pp)
class install_things_with_rvm {
    require rvm
    rvm_system_ruby {
      'ruby-1.9.3':
        ensure => 'present',
        default_use => true;
    }
    rvm_gem {
      'bundler':
        name => 'bundler',
        ruby_version => 'ruby-1.9.3',
        ensure => latest,
        require => Rvm_system_ruby['ruby-1.9.3'];
    }
    rvm_gem {
      'rails':
        name => 'rails',
        ruby_version => 'ruby-1.9.3',
        ensure => '3.2.14',
        require => Rvm_system_ruby['ruby-1.9.3'];
    }
    package{
      'sqlite-devel':
    	ensure => 'installed',
    	provider => 'yum'
    }
}

