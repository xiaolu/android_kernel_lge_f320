export PATH=$PATH:tools/lz4demo
TOOLCHAIN_LINARO="${HOME}/AK/AK-linaro/bin/arm-linux-gnueabihf-"
rm -rfv .config; rm -rfv .config.old
make CROSS_COMPILE=$TOOLCHAIN_LINARO ARCH=arm g2-lgu-perf_defconfig
make CROSS_COMPILE=$TOOLCHAIN_LINARO ARCH=arm -j4 zImage
