#!/bin/bash
BASEDIR="$PWD" #store our git dir to use our resources later.
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
cp $BASEDIR/ancora.xml ~/android/lineage/.repo/local_manifests/ancora.xml
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
git am $BASEDIR/patches/android_frameworks_base_simple_dialog.patch
cd ~/android/lineage/hardware/qcom/display-caf/msm7x30
git fetch --unshallow msm7x30
git revert 2bfbf21
cd ~/android/lineage/hardware/qcom/audio-caf/msm7x30
git fetch --unshallow msm7x30
git revert bc183a482dee3a54e0415fff64893da6f6bcacb7
cd ~/android/lineage/hardware/qcom/media-caf/msm7x30
git fetch --unshallow msm7x30
git revert 14c090d 
cd ~/android/lineage
sed -i 's/utf16_to_utf8(str,\slen,\s(char\*)\sdata)/utf16_to_utf8(str, len, (char*) data, len + 1)/g' hardware/qcom/media-caf/msm7x30/dashplayer/DashPlayer.cpp   
sed -i 's/#\sCamera/# Camera\'$'\nBOARD_USES_LEGACY_OVERLAY := true/g' device/samsung/ancora/BoardConfig.mk
sed -i 's/#\sTWRP\srecovery/# TWRP recovery\'$'\nRECOVERY_VARIANT := twrp/g' device/samsung/ancora/BoardConfig.mk
sed -i 's/RECOVERY_SDCARD_ON_DATA\s:=\strue//g' device/samsung/ancora/BoardConfig.mk
cp -f $BASEDIR/config.xml device/samsung/ancora/overlay/frameworks/base/core/res/res/values/
rm -R prebuilts/gcc/linux-x86/arm/arm-eabi-4.8
git clone https://bitbucket.org/UBERTC/arm-eabi-4.9 prebuilts/gcc/linux-x86/arm/arm-eabi-4.8
rm -R prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.8
git clone https://bitbucket.org/UBERTC/arm-linux-androideabi-4.9 prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.8
#Switch to old partition layout
git apply -R $BASEDIR/patches/Change_the_assignment_of_partitions_and_use_an_emulated_sdcard.patch $BASEDIR/patches/Switch_to_full_phone_config.patch --directory=~/android/lineage/device/samsung/ancora

#Revert libshims

java -version
javac -version

cd ~/android/lineage
source build/envsetup.sh
breakfast ancora eng
croot
#make clean
#lunch ancora-userdebug 
mka recoveryimage #brunch ancora
