#!/system/bin/sh

MODDIR=${0%/*}
EXPECTED_DEVICE="MD_PH_001"
EXPECTED_ANDROID="14"

if [ "$(getprop ro.product.device)" != "$EXPECTED_DEVICE" ] ||
   [ "$(getprop ro.build.version.release)" != "$EXPECTED_ANDROID" ]; then
    touch "$MODDIR/disable"
    exit 0
fi

MAGISKPOLICY="/data/adb/magisk/magiskpolicy"
[ -x "$MAGISKPOLICY" ] || MAGISKPOLICY="/system_ext/bin/magiskpolicy"
if [ -s "$MODDIR/sepolicy.rule" ] && [ -x "$MAGISKPOLICY" ]; then
    "$MAGISKPOLICY" --live --apply "$MODDIR/sepolicy.rule"
fi

chcon u:object_r:vendor_configs_file:s0 \
    "$MODDIR/system/vendor/etc/media_codecs_dolby_vision.xml" 2>/dev/null || true
chcon u:object_r:vendor_configs_file:s0 \
    "$MODDIR/system/vendor/etc/vintf/manifest/dvs-aidl-service.xml" 2>/dev/null || true
chcon u:object_r:vendor_configs_file:s0 \
    "$MODDIR/system/vendor/etc/vintf/manifest/vendor.dolby.media.c2.dv.xml" 2>/dev/null || true
chcon -R u:object_r:vendor_configs_file:s0 \
    "$MODDIR/system/vendor/odm/etc/dolby" 2>/dev/null || true
