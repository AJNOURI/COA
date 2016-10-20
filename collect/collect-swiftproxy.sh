#!/bin/bash


function cmd {
        echo
        echo
        echo $1
        $1
}

function node {
        echo 
        echo "@@@@@@@@@@@@@@"
        echo "@@@@@@@@@@@@@@@@@@@@@  $1  @@@@@@@@@@@@@@@@@@@@@"
        echo "@@@@@@@@@@@@@@"
        echo
}


node "Swift proxy node"
cmd "ping -c 3 controller"
cmd "telnet controller 8080"
cmd "service swift-proxy restart"
cmd "source admin-openrc.sh"
cmd "swift stat"
cmd "tail /var/log/syslog"
cmd "ls -la /etc/swift"
cmd "cat /etc/memcached.conf"
cmd "service memcached status"
cmd "cat /etc/swift/proxy-server.conf"
cmd "ls -la /etc/swift"
cmd "service swift-proxy status"
