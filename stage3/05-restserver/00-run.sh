#!/bin/bash -e

install -d ${ROOTFS_DIR}/usr/local/lib/ ${ROOTFS_DIR}/usr/local/sbin/

install -m 644 files/restserver.service ${ROOTFS_DIR}/etc/systemd/system/

on_chroot << EOF
  cd
  git clone https://github.com/babelouest/ulfius.git
  cd ulfius/
  git submodule update --init
  cd lib/orcania
  make && sudo make install
  cd ../yder
  make && sudo make install
  cd ../..
  make && sudo make install
  cd
  git clone https://github.com/8devices/wakaama.git
  cd wakaama
  mkdir build && cd build && cmake ../examples/rest-server && make
  install -m 755 restserver /usr/local/sbin/
  systemctl enable restserver
EOF
