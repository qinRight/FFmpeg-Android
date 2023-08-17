#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Invalid argument!"
    exit 1
fi

THIS_DIR=$(
    cd $(dirname "$0")
    pwd
)
FFMPEG_DIR=$1

echo "THIS_DIR=$THIS_DIR"

cd $FFMPEG_DIR
git clean -fdx

MODULES="\
--enable-gpl \
--enable-libx264"

FFMPEG_NORMAL_CONFIG = " --enable-zlib \
    --enable-static \
    --disable-shared \
    --disable-symver \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    --disable-ffplay \
    --disable-ffmpeg \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-bsfs \
    --disable-devices \
    --disable-protocols \
    --enable-zlib \
    --enable-protocol=file \
    --enable-protocol=pipe \
    --enable-protocol=concat \
    --disable-parsers \
    --enable-parser=h264 \
    --enable-parser=aac \
    --disable-demuxers \
    --enable-demuxer=mov \
    --enable-demuxer=mp3 \
    --enable-demuxer=aac \
    --enable-demuxer=mpegts \
    --enable-demuxer=image2 \
    --disable-decoders \
    --enable-decoder=aac \
    --enable-decoder=h264 \
    --enable-decoder=hevc \
    --enable-decoder=mp3 \
    --enable-decoder=png \
    --enable-decoder=mjpeg \
    --disable-muxers \
    --enable-muxer=mp4 \
    --enable-muxer=mov \
    --enable-muxer=mp3 \
    --enable-muxer=mpegts \
    --enable-muxer=image2 \
    --enable-muxer=hevc \
    --enable-demuxer=hevc \
    --enable-parser=hevc \
    --disable-encoders \
    --enable-encoder=aac \
    --enable-encoder=libx264 \
    --enable-encoder=png \
    --enable-encoder=mjpeg \
    --enable-gpl \
    --disable-network \
    --enable-hwaccels \
    --disable-avfilter \
    --enable-asm \
    --enable-version3 \
    ${MODULES} \
    --disable-doc \
    --enable-neon \
    --disable-filters \
    --enable-pic \
    --enable-yasm \
    --disable-linux-perf"


bash $THIS_DIR/build_android_armeabi_v7a.sh "$FFMPEG_DIR"

# Build arm64 v8a
bash $THIS_DIR/build_android_arm64_v8a.sh "$FFMPEG_DIR"

# Build x86
bash $THIS_DIR/build_android_x86.sh "$FFMPEG_DIR"

# Build x86_64
bash $THIS_DIR/build_android_x86_64.sh "$FFMPEG_DIR"

# Build mips
# bash $THIS_DIR/build_android_mips.sh "$FFMPEG_DIR"

# Build mips64   //may fail
# bash $THIS_DIR/build_android_mips64.sh "$FFMPEG_DIR"
