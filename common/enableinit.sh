#!/sbin/sh
# Created By SadiqDev
# init.d Support & About
# Also Installing Busybox & resolv.conf
# LeecoDrypt-Script Addon Installer

ir=/system/etc/install-recovery.sh
bb=/system/bin/busybox
xb=/system/xbin/busybox
sb=/system/bin/awk
sbx=/system/xbin/awk
xbp=/system/xbin

if [ -e /data/local.prop ];
then
	/tmp/busybox rm -f /data/local.prop
fi

# To prevent script from not running
# installing Busybox if Busybox not installed on your Device
if [ ! -e $bb ] && [ ! -e $sb ] && [ ! -e $xb ] && [ ! -e $sbx ];
then
	/tmp/busybox cp /tmp/busybox $xb
	/tmp/busybox chown 0.0 $xb
	/tmp/busybox chmod 4755 $xb
	$xb --install -s $xbp
fi
/tmp/busybox sleep 2
#
# Create Executor init.d
if [ ! -e $ir ];
then
	if [ ! -e /system/bin/sysinit ];
	then
		cat > $ir
		/tmp/busybox sleep 2
		/tmp/busybox echo "#!/system/bin/sh" >> $ir
		/tmp/busybox echo "#" >> $ir
		/tmp/busybox echo "busybox run-parts /system/etc/init.d/" >> $ir
		/tmp/busybox echo "" >> $ir
		/tmp/busybox chown 0.0 $ir
		/tmp/busybox chmod 4755 $ir
	else
		sys=`/tmp/busybox grep -l init.d /system/bin/sysinit`
		if [ $sys != "/system/bin/sysinit" ];
		then
		/tmp/busybox echo "/system/bin/logwrapper run-parts /system/etc/init.d" >> /system/bin/sysinit
		/tmp/busybox echo "" >> /system/bin/sysinit
		fi
	fi
else
	irx=`/tmp/busybox grep -l init.d /system/etc/install-recovery.sh`
	if [ $irx != "/system/etc/install-recovery.sh" ];
	then
		/tmp/busybox echo "busybox run-parts /system/etc/init.d/" >> $ir
		/tmp/busybox echo "" >> $ir
	fi
	/tmp/busybox chmod 4755 $ir
fi
#####
#######
# Create dns config ( Used Google : Strong Recomended )
if [ -e /system/etc/resolv.conf ];
then
	dns=`/tmp/busybox grep -l 8.8.8.8 /system/etc/resolv.conf`
	dns2=`/tmp/busybox grep -l 8.8.4.4 /system/etc/resolv.conf`
	if [ $dns != "/system/etc/resolv.conf" ] && [ $dns2 != "/system/etc/resolv.conf" ];
	then
		/tmp/busybox echo "nameserver 8.8.8.8" >> /system/etc/resolv.conf
		/tmp/busybox echo "nameserver 8.8.4.4" >> /system/etc/resolv.conf
	fi
else
	cat > /system/etc/resolv.conf
	/tmp/busybox echo "nameserver 8.8.8.8" >> /system/etc/resolv.conf
	/tmp/busybox echo "nameserver 8.8.4.4" >> /system/etc/resolv.conf
	sleep 1
	/tmp/busybox chmod 644 /system/etc/resolv.conf
fi
/tmp/busybox sleep 2
fi
