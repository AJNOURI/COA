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

echo "-------------  Check connectivity "
#cmd "ping -c 3 controller"
#cmd "ping -c 5 network"
#cmd "ping -c 5 block1"
node "controller node "
cmd "ping -c 3 swift"
cmd "ping -c 3 swiftProxy"
cmd "source admin-openrc.sh"
cmd "swift stat"
cmd "tail /var/log/syslog"
cmd "telnet controller 8080"
cmd "keystone user-list"
cmd "keystone service-list"
cmd "keystone endpoint-list"
cmd "ls -la /etc/swift"
cmd "cat /etc/swift/swift.conf"

ssh ajn@swift "bash -s" -- < ./collect-swift.sh
ssh ajn@swiftProxy "bash -s" -- < ./collect-swiftproxy.sh

