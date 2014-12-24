#!/bin/bash
sed -i -e 's/^\(.*pam_motd.so.*\)$/# \1/g' /etc/pam.d/sshd
