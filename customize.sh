AUTOMOUNT=true
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true
cd $MODPATH
StopInstalling() {
  rm -rf /data/adb/modules/read-write
  rm -rf /data/adb/modules/.rw
  exit 1
}
if [ -d "/data/adb/modules/read-write" ]; then
  rm -rf "/data/adb/modules/read-write"
  ui_print "▌*已删除旧模块"
fi
if [ "$KSU" = "true" ]; then
ui_print "▌*👺KernelSU=已安装*" 
ui_print "▌*👺KernelSU版本=$KSU_KERNEL_VER_CODE (kernel) + $KSU_VER_CODE (ksud)*" 
ui_print "▌*👺su版本=$(su -v)*" 
elif [ "$APATCH" = "true" ]; then
APATCH_VER=$(cat "/data/adb/ap/version")
ui_print "▌*👺APatch=已安装*" 
ui_print "▌*👺APatch版本=$APATCH_VER*" 
ui_print "▌*👺su版本=$(su -v)*" 
else
ui_print "▌*👺Magisk=已安装*" 
ui_print "▌*👺su版本=$(su -v)*" 
ui_print "▌*👺Magisk版本=$(magisk -v)*" 
ui_print "▌*👺Magisk版本号=$(magisk -V)*" 
StopInstalling
fi
EXTRACT() {
  ui_print "▌*为Magisk/KernelSU/APatch提取模块文件"
  unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
}
EXTRACT
PERMISSION() {
  ui_print "▌*正在设置权限"
  set_perm_recursive $MODPATH 0 0 0755 0755
}
PERMISSION
design_capacity=$(awk '{printf "%.0f", $0/1000}' /sys/class/power_supply/battery/charge_full_design)
current_capacity=$(awk '{printf "%.0f", $0/1000}' /sys/class/power_supply/battery/charge_full)
percentage=$(expr $current_capacity \* 100 / $design_capacity)
battery_usage_percentage=$(expr 100 - $percentage)
if [ -f "/sec/FactoryApp/bsoh" ]; then
    health=$(cat /sec/FactoryApp/bsoh)
else
    battery_info=$(/system/bin/dumpsys battery)
    health=$(echo "$battery_info" | sed -n 's/.*mSavedBatteryAsoc: \([^,]*\).*/\1/p')
fi
if [ -f "/efs/FactoryApp/batt_discharge_level" ]; then
    cycles_raw=$(cat /efs/FactoryApp/batt_discharge_level)
    cycles=$((cycles_raw / 100))
else
    battery_info=${battery_info:-$(/system/bin/dumpsys battery)}
    cycles_raw=$(echo "$battery_info" | sed -n 's/.*mSavedBatteryUsage: \([^,]*\).*/\1/p')
    cycles=$((cycles_raw / 100))
fi
ROM=$(getprop ro.build.description | awk '{print $1,$3,$4,$5}')
[[ $"ROM" == "" ]] && ROM=$(getprop ro.bootimage.build.description | awk '{print $1,$3,$4,$5}')
[[ $"ROM" == "" ]] && ROM=$(getprop ro.system.build.description | awk '{print $1,$3,$4,$5}')
ui_print "▌*  🅼 🅼 🆇   *" 
ui_print "▌*🛠️写入系统优化*" 
ui_print "▌*🕛执行日期=$(date)*"
ui_print "▌*📱系统信息=$(uname -a)*" 
ui_print "▌*👑名称ROM=$ROM ($(getprop ro.product.vendor.device))*" 
ui_print "▌*🔧内核=$(uname -r)-$(uname -v)*"
ui_print "▌*📱手机制造商=$(getprop ro.product.manufacturer)*" 
ui_print "▌*📱手机品牌=$(getprop ro.product.brand)*" 
ui_print "▌*📱设备型号=$(getprop ro.product.model)*" 
ui_print "▌*⛏️安全补丁=$(getprop ro.build.version.security_patch)*" 
ui_print "▌*🅰️Android版本=$(getprop ro.build.version.release)*" 
sleep 1
ui_print "▌*🔋当前电池百分比=$(cat /sys/class/power_supply/battery/capacity)%"
sleep 0.5
ui_print "▌*🔋电池设计=$design_capacity mAh"
sleep 0.5
ui_print "▌*🔋电池健康=$percentage%"
ui_print "▌*🔋电池损耗=$battery_usage_percentage%"
ui_print "▌*🔋电池循环=$cycles次"
sleep 0.5
ui_print "▌*🔋电池剩余容量=$current_capacity mAh"
ui_print "▌*🔨APatch-KSU通过OverlayFS可读写分区，通过删除/data/adb/modules/.rw文件夹恢复*"
if [ "$KSU" == "true" ] || [ "$APATCH" == "true" ]; then
su -c mkdir -p /data/adb/modules/.rw/{system,vendor,system_ext,product}/{upperdir,workdir}
    if [ $? -eq 0 ]; then
        ui_print "▌*通过OverlayFS可读写分区成功！"
    else
        ui_print "▌*通过OverlayFS可读写分区失败！"
    fi
fi
ui_print "▌*🛠️完成优化*"

