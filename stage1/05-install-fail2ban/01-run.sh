#!/bin/bash -e

install -m 644 files/jail.local "${ROOTFS_DIR}/etc/fail2ban/jail.local"
