main() {
  local node=$(ec2_hostname "$1")
  local public_dns="$2"
  wait_ssh_ready "$node"

  if ceph_initialized; then
    add_ceph_mon "$node"
    create_ceph_mds "$node"
    ceph_admin "$node"
    mount_cephfs "$node"
  fi

  set_zookeeper_myid "$node"
  set_zookeeper_cfg "$node"
  set_mesos_zk "$node"
  set_mesos_master_hostname "$node" "$public_dns"
  register_service "$node" zookeeper
  register_service "$node" mesos-master
  register_service "$node" marathon
}
