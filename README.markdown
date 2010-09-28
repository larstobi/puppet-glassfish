Puppet Glassfish Domain type
============================

This plugin for Puppet adds resource types and providers for managing Glassfish
domains and their system-properties by using the asadmin command line tool.

Copyright - Lars Tobias Skjong-Børsting <larstobi@conduct.no>

License: GPLv3

Example:
========

    Glassfish {
        user => "gfish",
        asadminuser => "admin",
        passwordfile => "/home/gfish/.aspass", 
    }   
    
    glassfish {
        "mydomain":
            ensure => present;

       "devdomain":
            portbase => "5000",
            profile => "devel",
            ensure => present;
    
        "myolddomain":
            ensure => absent;
    }
    
    Systemproperty {
        user => "gfish",
        asadminuser => "admin",
        passwordfile => "/home/gfish/.aspass",
    }
    
    systemproperty {
        "search-url":
            ensure => present,
            portbase => "5000",
            value => "http://www.google.com",
            require => Glassfish["devdomain"];
    }
