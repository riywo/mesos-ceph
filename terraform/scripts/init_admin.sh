main() {
  local node=$(ec2_hostname "$1")

  if ceph_initialized; then
    pull_ceph_info
    ceph_admin "$node"
  fi
}
