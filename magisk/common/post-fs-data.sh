#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

busybox="$MODDIR/system/etc/GovTuner/busybox"

ABI=$(cat /system/build.prop /default.prop | grep -m 1 "ro.product.cpu.abi=")
ABI2=$(cat /system/build.prop /default.prop | grep -m 1 "ro.product.cpu.abi2=")

if [ "$ABI" = "arm64-v8a" ]; then
	ARCH=arm

elif [ "$ABI" = "arm64-v8a" ]; then
	ARCH=arm

elif [ "$ABI" = "armeabi-v7a" ]; then
	ARCH=arm

elif [ "$ABI" = "armeabi-v7a" ]; then
	ARCH=arm

elif [ "$ABI" = "x86" ]; then
	ARCH=x86

elif [ "$ABI2" = "x86" ]; then
	ARCH=x86

elif [ "$ABI" = "x86_64" ]; then
	ARCH=x86

else

  ARCH=arm
fi

if [ ! -e $busybox ]; then
	ln -s $MODDIR/system/etc/GovTuner/busybox-install/$ARCH/busybox $busybox
	chmod 777 $busybox
	chown 0.2000 $busybox
fi