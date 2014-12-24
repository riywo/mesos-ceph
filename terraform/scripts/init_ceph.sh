main() {
  local admin=$(ec2_hostname "$1"); shift
  local master1=$(ec2_hostname "$1"); shift
  local master2=$(ec2_hostname "$1"); shift
  local master3=$(ec2_hostname "$1"); shift
  local masters="$master1 $master2 $master3"
  local slaves=$(for i in "$@"; do echo $(ec2_hostname "$i"); done)

  init_ceph $masters
  ceph_admin "$admin"

  for h in $slaves; do
    init_ceph_osd "$h"
    ceph_admin "$h"
  done

  for h in $masters; do
    create_ceph_mds "$h"
    ceph_gatherkeys "$h"
  done

  init_cephfs

  for h in $masters $slaves; do
    mount_cephfs "$h"
  done
}
