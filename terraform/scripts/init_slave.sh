main() {
  local node=$(ec2_hostname "$1")
  local public_dns="$2"
  wait_ssh_ready "$node"

  if ceph_initialized; then
    init_ceph_osd "$node"
    ceph_admin "$node"
    mount_cephfs "$node"
  fi

  set_mesos_zk "$node"
  set_mesos_slave_hostname "$node" "$public_dns"
  register_service "$node" mesos-slave
}
