#!/bin/bash

cd $1
echo "param = $1"
pwd

git clean -fdx

export NDK_STANDALONE_TOOLCHAIN=$NDK_TOOLCHAIN_DIR/x86
export SYSROOT=$NDK_STANDALONE_TOOLCHAIN/sysroot
export CROSS_PREFIX=$NDK_STANDALONE_TOOLCHAIN/bin/i686-linux-android-

GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--arch=x86 \
--cc=${CROSS_PREFIX}gcc \
--cross-prefix=$CROSS_PREFIX \
--nm=${CROSS_PREFIX}nm \
--extra-cflags="-I${PREFIX}/x264/x86/include" \
--extra-ldflags="-L${PREFIX}/x264/x86/lib" "

TEMP_PREFIX=${PREFIX}/ffmpeg/x86
rm -rf $TEMP_PREFIX
export PATH=$NDK_STANDALONE_TOOLCHAIN/bin:$PATH/

git clean -fdx
./configure \
    --target-os=linux \
    --prefix=${TEMP_PREFIX} \
    ${GENERAL} \
    --sysroot=$SYSROOT \
    --extra-cflags="-DANDROID -fPIC -O3 -ffunction-sections -funwind-tables -fstack-protector  -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -fasm -Wno-psabi -fno-short-enums -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32" \
    --extra-ldflags="-Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -nostdlib -lc -lm -ldl -llog -fPIC" \
    ${FFMPEG_NORMAL_CONFIG} \

make clean
make -j$(getconf _NPROCESSORS_ONLN)
make install

echo "Android x86 builds finished"
