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

#---Device specific repos---
mkdir -p ~/android/lineage/.repo/local_manifests
curl https://raw.githubusercontent.com/mtlive/cm12.1-build-ancora/master/ancora.xml -o ~/android/lineage/.repo/local_manifests/ancora.xml
#---

repo sync --quiet 



#Patches for ancora
git config --global user.email "you@example.com"
git config --global user.name "mt"
cd ~/android/lineage/bionic
git remote add ancora-bionic git://github.com/RR-msm7x30/android_bionic
git fetch ancora-bionic
git cherry-pick e480e8e 417890d 
cd ~/android/lineage/frameworks/native
git remote add ancora-fwnative git://github.com/sirmordred/android_frameworks_native
git fetch ancora-fwnative
git cherry-pick 10c3798 c3cda27 fd31f18 0c59f3f 
cd ~/android/lineage/frameworks/base
curl -O https://github.com/mtlive/cm12.1-build-ancora/raw/master/android_frameworks_base_simple_dialog.patch
git am android_frameworks_base_simple_dialog.patch
cd ~/android/lineage

#Updating libshims
#rm -R device/samsung/ancora/libshims/8
svn export --force https://github.com/sirmordred/android_device_samsung_ancora/branches/cm-13.0/libshims "device/samsung/ancora/libshims"
svn export --force https://github.com/sirmordred/android_device_samsung_ancora/branches/cm-13.0/camera "device/samsung/ancora/camera"

java -v
source build/envsetup.sh
cd ~/android/lineage
breakfast ancora
croot
brunch ancora

