#!/bin/bash
set -e

ec2_hostname() {
  declare ip="$1"
  echo ip-$(echo "$ip" | sed -e 's/\./-/g')
}

wait_ssh_ready() {
  declare node="$1"
  while ! ssh -o ConnectTimeout=3 "$node" true >/dev/null 2>&1; do
    sleep 1
  done
}

ceph_initialized() {
  local mons=$(for i in $(cat /home/ubuntu/masters); do echo $(ec2_hostname "$i"); done)
  for i in $mons; do
    if nc -z -w 3 "$i" 6789; then
      return 0
    fi
  done
  return 1
}

pull_ceph_info() {
  local mons=$(for i in $(cat /home/ubuntu/masters); do echo $(ec2_hostname "$i"); done)
  ceph_conf_pull $mons
  ceph_gatherkeys $mons
}

ceph_conf_pull() {
  local nodes="$@"
  ceph-deploy config pull $nodes
}

init_ceph() {
  local nodes="$@"
  new_ceph $nodes
  create_ceph_mon $nodes
  sleep 30
  ceph_gatherkeys $nodes
  ceph_admin $nodes
}

new_ceph() {
  local nodes="$@"
  ceph-deploy new $nodes
}

create_ceph_mon() {
  local nodes="$@"
  ceph-deploy mon create $nodes
}

ceph_gatherkeys() {
  local nodes="$@"
  ceph-deploy gatherkeys $nodes
}

add_ceph_mon() {
  declare node="$1"
  ceph-deploy mon add "$node"
}

create_ceph_mds() {
  declare node="$1"
  ceph-deploy mds create "$node"
}

init_ceph_osd() {
  declare node="$1"
  ceph-deploy osd create "$node":/dev/xvdb
  ceph-deploy osd activate "$node":/dev/xvdb1
}

ceph_admin() {
  local nodes="$@"
  ceph-deploy admin $nodes
}

init_cephfs() {
  sudo ceph osd pool create cephfs_data 64
  sudo ceph osd pool create cephfs_metadata 64
  sudo ceph fs new cephfs cephfs_metadata cephfs_data
  sudo ceph fs ls
  sudo ceph mds stat
}

mount_cephfs() {
  declare node="$1"
  local mons=$(sed -e 's/$/:6789/g' /home/ubuntu/masters | paste -s -d",")
  local secret=$(sudo ceph-authtool -p -n client.admin /etc/ceph/ceph.client.admin.keyring)
  ssh "$node" sudo mkdir /mnt/cephfs
  ssh "$node" sudo mount -t ceph "$mons":/ /mnt/cephfs -o name=admin,secret="$secret"
}

zk_id() {
  declare node="$1"
  local id=0
  for ip in $(cat /home/ubuntu/masters); do
    master=$(ec2_hostname "$ip")
    if [ "$node" == "$master" ]; then
      echo "$id"
      return
    else
      id=$(expr $id + 1)
    fi
  done
}

set_zookeeper_myid() {
  declare node="$1"
  local id=$(zk_id "$node")
  ssh "$node" "echo $id | sudo tee /etc/zookeeper/conf/myid"
}

set_zookeeper_cfg() {
  declare node="$1"
  local id=0
  for ip in $(cat /home/ubuntu/masters); do
    ssh "$node" "echo server.$id=$ip:2888:3888 | sudo tee -a /etc/zookeeper/conf/zoo.cfg"
    id=$(expr $id + 1)
  done
}

set_mesos_zk() {
  declare node="$1"
  local url=zk://$(sed -e 's/$/:2181/g' /home/ubuntu/masters | paste -s -d",")/mesos
  ssh "$node" "echo $url | sudo tee /etc/mesos/zk"
}

set_mesos_master_hostname() {
  declare node="$1" public_dns="$2"
  ssh "$node" "echo $public_dns | sudo tee /etc/mesos-master/hostname"
}

set_mesos_slave_hostname() {
  declare node="$1" public_dns="$2"
  ssh "$node" "echo $public_dns | sudo tee /etc/mesos-slave/hostname"
}

register_service() {
  declare node="$1" service="$2"
  ssh "$node" sudo rm -f /etc/init/"$service".override
  restart_service "$node" "$service"
}

restart_service() {
  declare node="$1" service="$2"
  ssh "$node" sudo service "$service" restart
}
