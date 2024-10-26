#!/bin/bash -e

install -m 644 files/ufw.conf "${ROOTFS_DIR}/etc/ufw/ufw.conf"
install -m 640 files/user.rules "${ROOTFS_DIR}/etc/ufw/user.rules"
install -m 640 files/user6.rules "${ROOTFS_DIR}/etc/ufw/user6.rules"
