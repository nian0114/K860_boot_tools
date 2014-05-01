#!/bin/sh
#===============================================================================
#
#          FILE: boot_test.sh
# 
#         USAGE: ./boot_test.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue(scue),
#  ORGANIZATION: 
#       CREATED: 2013年08月05日 03时04分29秒 HKT
#      REVISION:  ---
#===============================================================================

# fun: usage
usage(){
    echo
    echo "==> 联想K860/i boot recovery 解压、打包工具"
    echo
    echo -en "\e[0;31m" # color: red
    echo "==> 使用: $(basename $0) repack|unpack."
    echo "==> 备注: 打包后会自动刷入手机，如不希望刷入，不连接联想手机即可"
    echo -en "\e[0m"
    echo
}

self=$(readlink -f $0)
self_dir=/home/nian/k860
unpack_bootimage=boot.img
repack_bootimage=boot_new.img
device_specify_name=0123456789ABCDEF

# tool location
adb_tool=$self_dir/adb
fastboot_tool=$self_dir/fastboot
mkbootfs_tool=$self_dir/mkbootfs
mkimage_tool=$self_dir/mkimage
minigzip_tool=$self_dir/minigzip
mkbootimg_tool=$self_dir/mkbootimg
bootimg_tool=$self_dir/bootimg.py

    # repack root to ramdisk
    if [[ ! -d root/ ]]; then
        err "can't find a directory nameed 'root/'"
        exit 1
    fi
    info "打包 root/ 目录"
    $mkbootfs_tool root | $minigzip_tool > ramdisk.img.cpio
    # add ramdisk header
    info "添加 Ramdisk 文件首部信息"
    $mkimage_tool -A ARM -O Linux -T ramdisk -C none -a 0x40800000 -e 0x40800000 -n ramdisk -d ramdisk.img.cpio ramdisk.img.cpio.gz
    # make boot.img
    info "制作 $repack_bootimage 文件"
    $mkbootimg_tool --kernel kernel --ramdisk ramdisk.img.cpio.gz --cmdline "" --base 0x10000000 --pagesize 2048 --output $repack_bootimage
    tip "打包至 $repack_bootimage 完成"
