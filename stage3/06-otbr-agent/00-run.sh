#!/bin/bash -e

install -d ${ROOTFS_DIR}/etc/default/ ${ROOTFS_DIR}/usr/sbin/

install -m 644 files/otbr-agent.conf    ${ROOTFS_DIR}/etc/dbus-1/system.d/
install -m 644 files/otbr-agent.service ${ROOTFS_DIR}/etc/systemd/system/
install -m 644 files/otbr-agent.default ${ROOTFS_DIR}/etc/default/otbr-agent
install -m 755 files/otbr-agent         ${ROOTFS_DIR}/usr/sbin

install -m 644 files/otbr-agent-mdns.service    ${ROOTFS_DIR}/etc/systemd/system/
install -m 755 files/otbr-agent-mdns            ${ROOTFS_DIR}/usr/sbin/

on_chroot << EOF
  systemctl disable otbr-agent
  systemctl disable otbr-agent-mdns
EOF
