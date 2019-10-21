# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Soviet Zen kernel
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=raphael
device.name2=raphaelin
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

## AnyKernel install
dump_boot;

# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;
rm -rf $ramdisk/overlay.d;

# begin ramdisk changes
# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
if [ -d $ramdisk/.backup ]; then
	ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
	patch_cmdline "skip_override" "skip_override";
	mv /tmp/anykernel/overlay.d $ramdisk/overlay.d
	chmod -R 750 $ramdisk/overlay.d/*
	chown -R root:root $ramdisk/overlay.d/*
	chmod -R 755 $ramdisk/overlay.d/sbin/init.sov.sh
	chown -R root:root $ramdisk/overlay.d/sbin/init.sov.sh
else
	patch_cmdline "skip_override" "";
fi;

# end ramdisk changes

write_boot;
## end install

