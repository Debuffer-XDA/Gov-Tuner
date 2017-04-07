#!/sbin/sh
# Init.d enabler by ALEXNDR (_alexndr @ XDA)
#edited by veez21 to detect sysinit scripts in system

OUTFD=/proc/self/fd/$2

ui_print() {
    echo -n -e "ui_print $1\n" >> $OUTFD
    echo -n -e "ui_print\n" >> $OUTFD
}

set_perm() {
    chown $1.$2 $4
    chown $1:$2 $4
    chmod $3 $4
    if [ -z "$5" ] ; then
        chcon u:object_r:system_file:s0 $4
    else
        chcon u:object_r:$5:s0 $4
    fi
}

resolve_link() {
    if [ -z "$1" ] || [ ! -e $1 ] ; then return 1 ; fi
    local VAR=$1
    while [ -h "$VAR" ] ; do
        VAR=$(readlink $VAR)
    done
    echo $VAR
}

is_mounted() {
    if [ -z "$2" ] ; then
        cat /proc/mounts | grep $1 >/dev/null
    else
        cat /proc/mounts | grep $1 | grep "$2," >/dev/null
    fi
    return $?
}

ui_print " "
ui_print "=========================================="
ui_print "Init.d enabler by ALEXNDR (_alexndr @ XDA)"
ui_print "=========================================="
ui_print " "

SYSTEM=$(resolve_link $(find /dev/block/platform -type l | grep -i -m 1 "/app$")) ||
SYSTEM=$(resolve_link $(find /dev/block/platform -type l | grep -i -m 1 "/system$"))

if (! is_mounted /system) ; then mount -o rw /system ; fi
if (! is_mounted /system rw) ; then mount -o rw,remount /system ; fi
if (! is_mounted /system rw) ; then mount -t ext4 -o rw $SYSTEM /system ; fi
if (! is_mounted /system rw) ; then mount -t f2fs -o rw $SYSTEM /system ; fi
if (! is_mounted /system rw) ; then
    ui_print "Failed! Can't mount /system rw, aborting!"
    ui_print " "
    exit 1
fi

SYSLIB=/system/lib
cat /system/build.prop | grep "ro.product.cpu.abilist=" | grep "64" >/dev/null && SYSLIB=/system/lib64
cat /system/build.prop | grep "ro.product.cpu.abi=" | grep "64" >/dev/null && SYSLIB=/system/lib64

# These files are prefered to trigger init.d scripts (in following order, if exists):
# /system/etc/init.*.post_boot.sh
# /system/etc/*.post_boot.sh
# /system/etc/init.*.boot.sh
# /system/etc/*.boot.sh
#
# /system/bin/debuggerd is used if there is no suitable *.sh file in /system/etc

#if sysinit is present, abort
if [ -x /system/bin/sysinit -o -x /system/xbin/sysinit ]; then
exit
fi

BOOTFILE=$(ls /system/etc/*.sh 2>/dev/null | grep -m 1 "/init\..*\.post_boot\.sh$") ||
BOOTFILE=$(ls /system/etc/*.sh 2>/dev/null | grep -m 1 "\.post_boot\.sh$") ||
BOOTFILE=$(ls /system/etc/*.sh 2>/dev/null | grep -m 1 "/init\..*\.boot\.sh$") ||
BOOTFILE=$(ls /system/etc/*.sh 2>/dev/null | grep -m 1 "\.boot\.sh$") ||
BOOTFILE=/system/bin/debuggerd

BOOTCON=$(ls -Z $BOOTFILE 2>/dev/null | grep "u:object_r" | cut -d: -f3)
if [ -z "$BOOTCON" ] ; then
    BOOTCON=$(LD_LIBRARY_PATH=$SYSLIB /system/bin/toolbox ls -Z $BOOTFILE 2>/dev/null | grep "u:object_r" | cut -d: -f3)
fi
if [ -z "$BOOTCON" ] ; then
    BOOTCON=$(LD_LIBRARY_PATH=$SYSLIB /system/bin/toybox ls -Z $BOOTFILE 2>/dev/null | grep "u:object_r" | cut -d: -f3)
fi
if [ -z "$BOOTCON" ] ; then
    BOOTCON=system_file
fi

cat $BOOTFILE | grep "^exit 0" >/dev/null && EXIT=true || EXIT=false

if [ -z "$(cat $BOOTFILE | grep "Init\.d")" ] ; then
    if [ "$BOOTFILE" = "/system/bin/debuggerd" ] ; then
        if [ ! -f /system/bin/debuggerd_real ] ; then
            mv -f $BOOTFILE /system/bin/debuggerd_real
            echo "#!/system/bin/sh" > $BOOTFILE
        else
            sed -i '/debuggerd_real/d' $BOOTFILE
        fi
    else
        mv -f $BOOTFILE "$BOOTFILE.bak"
        cp -pf "$BOOTFILE.bak" $BOOTFILE
        if ($EXIT) ; then sed -i '/^exit 0/d' $BOOTFILE ; fi
        echo "" >> $BOOTFILE
    fi
    echo "# Init.d support" >> $BOOTFILE
    echo 'SU="$(ls /su/bin/su 2>/dev/null || ls /system/xbin/su) -c"' >> $BOOTFILE
    echo 'mount -o rw,remount /system && SU="" || eval "$SU mount -o rw,remount /system"' >> $BOOTFILE
    echo 'eval "$SU chmod 777 /system/etc/init.d"' >> $BOOTFILE
    echo 'eval "$SU chmod 777 /system/etc/init.d/*"' >> $BOOTFILE
    echo 'eval "$SU mount -o ro,remount /system"' >> $BOOTFILE
    echo 'ls /system/etc/init.d/* 2>/dev/null | while read xfile ; do eval "$SU /system/bin/sh $xfile" ; done' >> $BOOTFILE
    if [ "$BOOTFILE" = "/system/bin/debuggerd" ] ; then
        echo '/system/bin/debuggerd_real $@' >> $BOOTFILE
        set_perm 0 2000 755 $BOOTFILE $BOOTCON
    else
        if ($EXIT) ; then echo "exit 0" >> $BOOTFILE ; fi
        chcon u:object_r:$BOOTCON:s0 $BOOTFILE
    fi
    mkdir -p /system/etc/init.d
    echo "#!/system/bin/sh" > /system/etc/init.d/00test
    echo "# Init.d test" >> /system/etc/init.d/00test
    echo 'echo "Init.d is working !!!" > /data/initd_test.log' >> /system/etc/init.d/00test
    echo 'echo "excecuted on $(date +"%d-%m-%Y %r")" >> /data/initd_test.log' >> /system/etc/init.d/00test
    echo "#!/system/bin/sh" > /system/etc/init.d/99SuperSUDaemon
    echo "/system/xbin/daemonsu --auto-daemon &" >> /system/etc/init.d/99SuperSUDaemon
    set_perm 0 0 777 /system/etc/init.d
    set_perm 0 0 777 "/system/etc/init.d/*"
    ui_print "Init.d has been successfully enabled"
    ui_print "using following file run at boot:"
    ui_print " "
    ui_print "$BOOTFILE"
    ui_print " "
    ui_print "Check result in /data/initd_test.log file"
    ui_print " "
else
    ui_print "Init.d is enabled already, aborting!"
    ui_print " " # exit is not necessary
fi

exit 0
