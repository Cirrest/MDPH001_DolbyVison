#!/system/bin/sh

# Magisk removes module mounts on reboot. Leave the live services and bind
# mount intact until then so MediaCodecList never points at a stopped store.
exit 0
