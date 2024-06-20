#!/system/bin/sh
[ ! "$MODDIR" ] && MODDIR=${0%/*}
function log() {
logfile=1000000
maxsize=1000000
if  [[ "$(stat -t ${MODDIR}/scripts/ll/log/优化.log | awk '{print $2}')" -eq "$maxsize" ]] || [[ "$(stat -t ${MODDIR}/scripts/ll/log/优化.log | awk '{print $2}')" -gt "$maxsize" ]]; then
rm -f "${MODDIR}/scripts/ll/log/优化.log"
fi
}
[[ ! -e ${MODDIR}/scripts/ll/log ]] && mkdir -p ${MODDIR}/scripts/ll/log
cd ${MODDIR}/scripts/ll/log
log
export ROOT=$({ROOT_PERMISSION})
rt() {
    if $ROOT; then
        echo "已ROOT"
        echo "su文件：`which -a su`"
    else
        echo "未ROOT"
    fi
}
root=$(magisk -c) 
echo "$date *👺ROOT状态=`rt`$root*" >>优化.log
if [ "$KSU" = "true" ]; then
echo "$date *👺KernelSU版本=$KSU_KERNEL_VER_CODE (kernel) + $KSU_VER_CODE (ksud)*" >>优化.log
elif [ "$APATCH" = "true" ]; then
APATCH_VER=$(cat "/data/adb/ap/version")
echo "$date *👺APatch版本=$APATCH_VER*" >>优化.log
else
echo "$date *👺Magisk=已安装*" >>优化.log
echo "$date *👺su版本=$(su -v)*" >>优化.log
echo "$date *👺Magisk版本=$(magisk -v)*" >>优化.log
echo "$date *👺Magisk版本号=$(magisk -V)*" >>优化.log
echo "$date *👺Magisk路径=$(magisk --path)*" >>优化.log
rm -rf /data/adb/modules/read-write
fi

