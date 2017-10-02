#!/bin/bash -e

install -d ${ROOTFS_DIR}/usr/local/lib/ ${ROOTFS_DIR}/usr/local/sbin/

install -m 755 files/liborcania.so.1.1 ${ROOTFS_DIR}/usr/local/lib/
install -m 755 files/libyder.so.2.0    ${ROOTFS_DIR}/usr/local/lib/
install -m 755 files/libulfius.so.2.1  ${ROOTFS_DIR}/usr/local/lib/
ln -sf liborcania.so.1.1 ${ROOTFS_DIR}/usr/local/lib/liborcania.so
ln -sf libyder.so.2.0    ${ROOTFS_DIR}/usr/local/lib/libyder.so
ln -sf libulfius.so.2.1  ${ROOTFS_DIR}/usr/local/lib/libulfius.so

install -m 755 files/restserver        ${ROOTFS_DIR}/usr/local/sbin/

install -m 644 files/restserver.service ${ROOTFS_DIR}/etc/systemd/system/

on_chroot << EOF
  systemctl enable restserver
EOF
