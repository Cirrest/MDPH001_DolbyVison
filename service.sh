#!/system/bin/sh

MODDIR=${0%/*}
EXPECTED_DEVICE="MD_PH_001"
EXPECTED_ANDROID="14"
LIBDIR="$MODDIR/payload/lib64"
BINDIR="$MODDIR/payload/bin"
RUNTIME_DIR="$MODDIR/runtime"
LIVE_MEDIA_XML="/vendor/etc/media_codecs.xml"
MERGED_MEDIA_XML="$RUNTIME_DIR/media_codecs.xml"
LIBPATH="$LIBDIR:/apex/com.android.media.swcodec/lib64:/system/lib64:/system_ext/lib64:/vendor/lib64:/odm/lib64"
DVS_PID=""
CODEC_PID=""

disable_module() {
    touch "$MODDIR/disable"
    exit 0
}

dvs_registered() {
    service check vendor.dolby.dvs.IDvs/default 2>/dev/null | grep -q ': found$'
}

wait_for_surfaceflinger() {
    attempt=0
    while [ "$attempt" -lt 120 ]; do
        pidof surfaceflinger >/dev/null 2>&1 && return 0
        sleep 0.25
        attempt=$((attempt + 1))
    done
    return 1
}
#C2声明

prepare_media_codec_overlay() {
    [ -r "$LIVE_MEDIA_XML" ] || return 1
    mkdir -p "$RUNTIME_DIR" || return 1
    cp -f "$LIVE_MEDIA_XML" "$MERGED_MEDIA_XML" || return 1
    if ! grep -q 'media_codecs_dolby_vision.xml' "$MERGED_MEDIA_XML"; then
        grep -q '</MediaCodecs>' "$MERGED_MEDIA_XML" || return 1
        sed -i '/<\/MediaCodecs>/i\    <Include href="media_codecs_dolby_vision.xml" />' \
            "$MERGED_MEDIA_XML" || return 1
    fi
    chown 0:0 "$MERGED_MEDIA_XML" || return 1
    chmod 0644 "$MERGED_MEDIA_XML" || return 1
    chcon u:object_r:vendor_configs_file:s0 "$MERGED_MEDIA_XML" \
        2>/dev/null || return 1
    mount -o bind "$MERGED_MEDIA_XML" "$LIVE_MEDIA_XML" \
        2>/dev/null || return 1
    grep -q 'media_codecs_dolby_vision.xml' "$LIVE_MEDIA_XML"
}

apply_display_overrides() {
    setprop debug.sf.disable_hwc 1 >/dev/null 2>&1 || return 1
    service call SurfaceFlinger 1008 i32 1 >/dev/null 2>&1 || return 1
    "$BINDIR/dv-displayctl" 1 2 3 4 >/dev/null 2>&1
}

wait_for_dvs() {
    attempt=0
    while [ "$attempt" -lt 60 ]; do
        dvs_registered && return 0
        sleep 0.25
        attempt=$((attempt + 1))
    done
    return 1
}

wait_for_codec2() {
    timeout 20 lshal wait \
        'android.hardware.media.c2@1.0::IComponentStore/dolby' \
        >/dev/null 2>&1
}

if [ "$(getprop ro.product.device)" != "$EXPECTED_DEVICE" ] ||
   [ "$(getprop ro.build.version.release)" != "$EXPECTED_ANDROID" ]; then
    disable_module
fi

prepare_media_codec_overlay || exit 0
wait_for_surfaceflinger || exit 0
apply_display_overrides || exit 0

if ! dvs_registered; then
    LD_LIBRARY_PATH="$LIBPATH" "$BINDIR/dvs-aidl-service" >/dev/null 2>&1 &
    DVS_PID=$!
fi
if ! wait_for_dvs; then
    [ -z "$DVS_PID" ] || kill "$DVS_PID" 2>/dev/null
    exit 0
fi

if ! pidof dolbycodec2 >/dev/null 2>&1; then
    LD_LIBRARY_PATH="$LIBPATH" \
    LD_PRELOAD="$LIBDIR/libdvcompat.so" \
        "$BINDIR/dolbycodec2" >/dev/null 2>&1 &
    CODEC_PID=$!
fi
if ! wait_for_codec2; then
    [ -z "$CODEC_PID" ] || kill "$CODEC_PID" 2>/dev/null
    [ -z "$DVS_PID" ] || kill "$DVS_PID" 2>/dev/null
    exit 0
fi

setprop ctl.restart media
exit 0
