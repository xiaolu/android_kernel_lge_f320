#!/bin/bash

clear

#
# VAR
#
export PATH=$PATH:tools/lz4demo
PARAM=$1
DATE_START=$(date +"%s")
CWM_MOVE="/home/franco-c/"
TOOLCHAIN_LINARO="${HOME}/AK/AK-google/arm-eabi-4.6/bin/arm-eabi-"

 echo ""; echo "# G2 SPECIAL EDITION START ///\\\ ------------------------------------------------------------------------------------------------"; echo ""
  #
  # CREATE DEFAULT CONFIG
  #
  if [ "$PARAM" == "clean" ]
  then
     echo "Cleaning out folder..."
     make clean; sleep 3; make distclean; sleep 3
  else
    echo ""
    echo "Skipping cleaning..."
  fi
  rm -rfv .config; rm -rfv .config.old

   echo ""
  #make CROSS_COMPILE=$TOOLCHAIN_GOOGLE ARCH=arm g2-lgu-perf_defconfig
  make CROSS_COMPILE=$TOOLCHAIN_LINARO ARCH=arm g2-lgu-perf_defconfig


  g2_ver="G2.JB42.001";

  debug=0

#
# CROSS COMPILE KERNEL WITH TOOLCHAIN
#
make CROSS_COMPILE=$TOOLCHAIN_LINARO ARCH=arm -j4 zImage

#
# COPY IMAGE OF KERNEL
# FOR MERGE WITH RAMDISK
#
cp -vr arch/arm/boot/zImage ../G2-ramdisk/
cd ../G2-ramdisk/ramdisk-4.2/
chmod 750 init*
chmod 750 charger
chmod 644 default.prop
chmod 644 ueventd*
cd ..
./repack-bootimg.pl zImage ramdisk-4.2/ boot.img
cp -vr boot.img cwm/

#
# CREATE A CWM PKG
# FOR FLASH FROM RECOVERY
#
cd cwm
zip -r `echo $g2_ver`.zip *
rm -rf $CWM_MOVE/`echo $g2_ver`.zip
cp -vr `echo $g2_ver`.zip $CWM_MOVE/G2-kernel/
if [ ! -d ../zip ]; then
 mkdir ../zip
fi
mv `echo $g2_ver`.zip ../zip/
rm -rf `echo $g2_ver`.zip boot.img
cd ~/G2

echo .
echo ..
echo ... Compile Complete ! ... `echo $g2_ver`.zip
echo ..
echo .

#
# PRINT BUILDING COMPILE-TIME
#
echo ""
DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo ""
