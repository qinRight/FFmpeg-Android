#!/bin/bash

cd $1
echo "param = $1"
pwd

git clean -fdx

export NDK_STANDALONE_TOOLCHAIN=$NDK_TOOLCHAIN_DIR/arm64
export SYSROOT=$NDK_STANDALONE_TOOLCHAIN/sysroot
export CROSS_PREFIX=$NDK_STANDALONE_TOOLCHAIN/bin/aarch64-linux-android-

GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--arch=aarch64 \
--cc=${CROSS_PREFIX}gcc \
--cross-prefix=$CROSS_PREFIX \
--nm=${CROSS_PREFIX}nm \
--extra-cflags="-I${PREFIX}/x264/arm64-v8a/include" \
--extra-ldflags="-L${PREFIX}/x264/arm64-v8a/lib" "

TEMP_PREFIX=${PREFIX}/ffmpeg/arm64-v8a
rm -rf $TEMP_PREFIX
export PATH=$NDK_STANDALONE_TOOLCHAIN/bin:$PATH/

git clean -fdx
./configure \
    --target-os=linux \
    --prefix=${TEMP_PREFIX} \
    ${GENERAL} \
    --sysroot=$SYSROOT \
    --extra-cflags="-DANDROID -O3 -fPIC -ffunction-sections -funwind-tables -fstack-protector  -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300" \
    --extra-ldflags="-Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -nostdlib -lc -lm -ldl -llog -fPIC" \
    ${FFMPEG_NORMAL_CONFIG} \

make clean
make -j$(getconf _NPROCESSORS_ONLN)
make install

echo "Android arm64-v8a builds finished"
