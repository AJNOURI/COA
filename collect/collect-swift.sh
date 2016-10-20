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


node "Swift node"
cmd "df -h"
cmd "cat /etc/rsyncd.conf"
cmd "cat /etc/default/rsync"
cmd "service rsync status"
cmd "cat /etc/swift/swift.conf"
cmd "ls -la /var/swift/recon"
cmd "ls -la /etc/swift"
cmd "for service in swift-object swift-object-replicator swift-object-updater swift-object-auditor swift-container swift-container-replicator swift-container-updater swift-container-auditor swift-account swift-account-replicator swift-account-updater swift-account-auditor ; do service $service start; done"
