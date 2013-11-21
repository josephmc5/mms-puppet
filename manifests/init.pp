class mms {
    file { "/root/10gen-mms-agent.tar.gz":
        ensure => present,
        source => "puppet:///modules/mms/10gen-mms-agent.tar.gz",
    }
    file { "/opt":
        ensure => directory,
    }
    package { "pymongo":
        ensure => present,
        provider => pip,
    }
    exec { "tar zxf /root/10gen-mms-agent.tar.gz -C /opt":
        creates => "/opt/mms-agent/agent.py",
        require => [File["/root/10gen-mms-agent.tar.gz"], Package["pymongo"]],
        path    => ['/bin/', '/usr/bin/'],
    }
    file { "/var/log/mms-agent":
        ensure => directory,
    }
    file { "/etc/init/mms-agent.conf":
        ensure => present,
        source => "puppet:///modules/mms/mms-agent.init",
        mode    => "755",
    }
    file { "/etc/init.d/mms-agent":
        ensure  => link,
        target  =>  "/lib/init/upstart-job",
        require => File["/etc/init/mms-agent.conf"],
    }
    service {"mms-agent":
        ensure => running,
        enable => true,
        require => [File["/var/log/mms-agent", "/etc/init/mms-agent.conf"], Exec["tar zxf /root/10gen-mms-agent.tar.gz -C /opt"]],
    }
}
