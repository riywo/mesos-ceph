#!/bin/bash
sudo apt-get install -y ca-certificates wget

wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
echo deb http://ceph.com/debian-giant/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list >/dev/null
sudo apt-get update

sudo apt-get install -y ceph ceph-mds ceph-common ceph-fs-common gdisk
