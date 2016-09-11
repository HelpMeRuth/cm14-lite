#!/bin/bash
set -e
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/ruthger/android/arm-eabi-6.x/bin/arm-eabi-
make osprey_defconfig
# make menuconfig i edit the defconfig directly.
rm -f arch/arm/boot/dts/*.dtb
rm -f arch/arm/boot/dt.img
rm -f cwm_flash_zip/boot.img
make CONFIG_NO_ERROR_ON_MISMATCH=y -j2 zImage
make -j2 dtimage
make -j2 modules
rm -rf kernel_install
mkdir -p kernel_install
make -j2 modules_install INSTALL_MOD_PATH=kernel_install INSTALL_MOD_STRIP=1
mkdir -p cwm_flash_zip/system/lib/modules/pronto
find kernel_install/ -name '*.ko' -type f -exec cp '{}' cwm_flash_zip/system/lib/modules/ \;
mv cwm_flash_zip/system/lib/modules/wlan.ko cwm_flash_zip/system/lib/modules/pronto/pronto_wlan.ko
cp arch/arm/boot/zImage cwm_flash_zip/tools/
cp arch/arm/boot/dt.img cwm_flash_zip/tools/
rm -f arch/arm/boot/kernel.zip
cd cwm_flash_zip
zip -r ../arch/arm/boot/kernel.zip ./
