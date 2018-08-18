#!/bin/sh

cd ~/android/lineage
#rm -R device/samsung/ancora/libshims/8
svn --force checkout https://github.com/doadin/android_device_samsung_ancora_tmo/branches/cm-12.1_ion_pmem-libshim/libshims "device/samsung/ancora/libshims"
ls
breakfast ancora
croot
brunch ancora
cd $OUT
ls -l
