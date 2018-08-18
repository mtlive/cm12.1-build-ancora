#!/bin/bash
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip -qq platform-tools-latest-linux.zip -d ~
PATH="$(pwd)/platform-tools:$PATH"
mkdir -p ~/bin
mkdir -p ~/android/lineage
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
PATH="$(pwd)/bin:$PATH"
source ~/.profile
cd ~/android/lineage
repo init --depth=1 -u git://github.com/LineageOS/android.git --quiet -b cm-12.1  <<!
y
y
!

#---Device specific---
mkdir -p ~/android/lineage/.repo/local_manifests
curl https://raw.githubusercontent.com/mtlive/cm12.1-build-ancora/master/ancora.xml -o ~/android/lineage/.repo/local_manifests/ancora.xml
#---

repo sync --quiet 
source build/envsetup.sh
cd ~/android/lineage

#Updating libshims
#rm -R device/samsung/ancora/libshims/8
svn export --force https://github.com/doadin/android_device_samsung_ancora_tmo/branches/cm-12.1_ion_pmem-libshim/libshims "device/samsung/ancora/libshims"
#---

breakfast ancora
croot
brunch ancora

