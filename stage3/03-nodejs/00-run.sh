#!/bin/bash -e


########################
# Install dependencies #
########################
dpkg --add-architecture i386

apt-get update
apt-get install -y make python build-essential
apt-get install -y gcc-multilib g++-multilib
apt-get install -y libc6-dev-i386
apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

apt-get install -y libc6-dev

apt-get --purge remove node
apt-get --purge remove nodejs
apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_6.x | /bin/bash -e -
apt-get install -y nodejs
npm install -g npm@5
npm cache clean --force
#find / -iname npm
#nodejs -v
#node -v
#npm -v

ln -s /usr/include/asm-generic /usr/include/asm


##apt-get install -y curl
##apt-get install -y locate

#echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/crosstools.list
#curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
##dpkg --add-architecture armhf

##apt-get update
##apt-cache search armhf | more
#cat /etc/apt/sources.list | more
uname -a | more
#apt-get install -y make libc6 libc6-dev
##apt-get install -y make gcc-multilib g++-multilib
##apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
#apt-get install -y make libc6 libc6-dev libc6-dev-i386 gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
#apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

##locate sys/cdefs.h
##apt-get install -y python

#################
# Checkout node #
#################
NODE_BUILD_PATH=$(pwd)/build/node
git clone https://github.com/nodejs/node.git $NODE_BUILD_PATH
cd $NODE_BUILD_PATH
git checkout v6.10.3


#######################
# Cross-build Node.js #
#######################
 
#export BASEDIR=$(pwd)
#export STAGING_DIR=${BASEDIR}/staging_dir
#export V8SOURCE=${BASEDIR}/v8m-rb
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
file /usr/arm-linux-gnueabihf/lib/libstdc++.so.6*
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
file ${ROOTFS_DIR}/usr/lib/arm-linux-gnueabihf/libstdc++.so.6*
echo "#################################"
export PREFIX=arm-linux-gnueabihf-
export LIBPATH=${ROOTFS_DIR}/usr/lib/arm-linux-gnueabihf/
export TARGET_PATH=${ROOTFS_DIR}
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
ls -la ${LIBPATH}
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
#mv /usr/arm-linux-gnueabihf/lib/ /usr/arm-linux-gnueabihf/lib_bak/
#ln -s ${LIBPATH} /usr/arm-linux-gnueabihf/lib
#export LIBRARY_PATH=${LIBPATH}
#cp -r ${LIBPATH}/* /usr/arm-linux-gnueabihf/lib/.
cp -r /usr/arm-linux-gnueabihf/lib/* ${LIBPATH}/.
echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

# ARM cross-compile exports
export CC=${PREFIX}gcc
export CXX=${PREFIX}g++
export AR=${PREFIX}ar
export RANLIB=${PREFIX}ranlib
export LINK=${PREFIX}g++
export CPP="${PREFIX}gcc -E"
export STRIP=${PREFIX}strip
export OBJCOPY=${PREFIX}objcopy
export LD=${PREFIX}g++
export OBJDUMP=${PREFIX}objdump
export NM=${PREFIX}nm
export AS=${PREFIX}as
export PS1="[${PREFIX}] \w$ "
#export LDFLAGS='-Wl,-L'${LIBPATH}
export LDFLAGS='-Wl,-rpath-link '${LIBPATH}
 
export TARGET_ARCH="-march=armv7l"
#export TARGET_TUNE="-mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -mthumb-interwork -mno-thumb"
export CXX_TARGET_ARCH="-march-armv7l"

export V8_TARGET_ARCH="-march-armv7l"
export CXX_host="g++ -m32"
export CC_host="gcc -m32" 
export LINK_host="g++ -m32"

 
make clean
make distclean
 
#./configure --prefix=${TARGET_PATH} --dest-cpu=arm --dest-os=linux --without-snapshot --with-arm-float-abi=hard --with-arm-fpu=vfpv3
./configure --prefix=${TARGET_PATH} --dest-cpu=arm --dest-os=linux --without-snapshot --with-arm-float-abi=hard --with-arm-fpu=vfpv3 --without-intl

#./configure --without-snapshot --dest-cpu=arm --dest-os=linux --with-arm-float-abi=softfp --with-intl=full-icu --download=all
 
make snapshot=off -j4
make install


#########################
# Install node packages #
#########################

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
# WAR for node-gyp build
mkdir -p ${ROOTFS_DIR}/lib/node_modules/node-red/node_modules/bcrypt
chown -R $USER:$GROUP ${ROOTFS_DIR}/lib/node_modules/node-red/node_modules/bcrypt

mkdir -p ${ROOTFS_DIR}/lib/node_modules/node-red/node_modules/bcrypt/build
chown -R $USER:$GROUP ${ROOTFS_DIR}/lib/node_modules/node-red/node_modules/bcrypt/build

ls -la ${ROOTFS_DIR}/lib/node_modules/node-red/node_modules/bcrypt/build
ls -la ${ROOTFS_DIR}
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

export npm_config_arch=arm
export npm_config_nodedir=${NODE_BUILD_PATH}

npm_install () {
  npm install -g --prefix=${TARGET_PATH} --target_arch=arm --target_platform=linux "$1"
#on_chroot << EOF
#npm install -g --target_arch=arm --target_platform=linux "$1"
#EOF
}

npm --prefix=${TARGET_PATH} --target_arch=arm --target_platform=linux cache clean --force

npm_install npm@5
echo "111111111111111111"
npm_install node-red
echo "222222222222222222"
npm_install coap
echo "33333333333333333333"

