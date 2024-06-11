#!/system/bin/sh
MODDIR=${0%/*}
if [[ "$MAGISK_VER" == "true" ]] || [[ "$MAGISK_VER_CODE" == "true" ]]; then
rm -rf "/data/adb/modules/read-write"
elif [[ "$KSU" == "true" ]] || [[ "$APATCH" == "true" ]]; then
[[ ! -d /data/adb/modules/.rw ]] && (
su -c mkdir -p /data/adb/modules/.rw/system
su -c mkdir -p /data/adb/modules/.rw/system/upperdir
su -c mkdir -p /data/adb/modules/.rw/system/workdir
)
fi
rm -f "${0}"