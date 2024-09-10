#!/system/bin/sh
MODDIR=${0%/*}
if [[ "$KSU" == "true" ]] || [[ "$APATCH" == "true" ]]; then
[[ ! -d /data/adb/modules/.rw ]] && (
su -c mkdir -p /data/adb/modules/.rw/{system,vendor,system_ext,product}/{upperdir,workdir}
)
fi
rm -f "${0}"