Puppet Glassfish Domain type
============================

This plugin for Puppet adds resource types and providers for managing Glassfish
domains, system-properties, jdbc-connection-pools, jdbc-resources, auth-realms
and application deployment by using the asadmin command line tool.

Copyright - Lars Tobias Skjong-Børsting <larstobi@conduct.no>

License: GPLv3

Installation:
=============
This plugin uses the executable "asadmin". For this plugin to work, the
folder where the executable is located must exist in the PATH environment
variable.

Place the "lib" folder and it's subfolders in the module path,
i.e. /etc/puppet/modules/glassfish/lib/...

Example:
========

    Domain {
        user => "gfish",
        asadminuser => "admin",
        passwordfile => "/home/gfish/.aspass", 
    }   
    
    domain {
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
            require => Domain["devdomain"];
    }
    
    Jdbcconnectionpool {
        ensure => present,
        user => "gfish",
        asadminuser => "admin",
        passwordfile => "/home/gfish/.aspass",
        datasourceclassname => "com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource",
        resourcetype => "javax.sql.ConnectionPoolDataSource",
        require => Glassfish["mydomain"],
    }
    
    jdbcconnectionpool {
        "MyPool":
            properties => "password=mYPasS:user=myuser:url=jdbc\:mysql\://host.ex.com\:3306/mydatabase:useUnicode=true:characterEncoding=utf8:characterResultSets=utf:autoReconnect=true:autoReconnectForPools=true";
    }
    
    Jdbcresource {
        ensure => present,
        user => "gfish",
        passwordfile => "/home/gfish/.aspass",
    }
    
    jdbcresource {
        "jdbc/MyPool":
            connectionpool => "MyPool",
    }
    
    Application {
        ensure => present,
        user => "gfish",
        passwordfile => "/home/gfish/.aspass",
    }
    
    application {
        "pluto":
            source => "/home/gfish/pluto.war";
        
        "myhello":
            source => "/home/gfish/hello.war",
            require => Application["pluto"];
    }
    
    Jvmoption {
        ensure => present,
        user => "gfish",
        passwordfile => "/home/gfish/.aspass",
    }
    
    jvmoption {
        ["-DjvmRoute=01", "-server"]:
    }

    authrealm {
        ensure => present,
        user => "gfish",
        asadminuser => "admin",
        passwordfile => "/Users/larstobi/.aspass",
    }
    
    authrealm {
        "agentRealm":
            ensure => present,
            classname => "com.sun.identity.agents.appserver.v81.AmASRealm",
            properties => ["jaas-context=agentRealm:foo=bar"],
            require => Domain["mydomain"];
    }
