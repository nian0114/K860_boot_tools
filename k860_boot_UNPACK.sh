#!/bin/sh
    echo "#==============================================================================="
    echo "#"
    echo "#          FILE: boot_test.sh"
    echo "# "
    echo "#         USAGE: ./boot_test.sh "
    echo "# "
    echo "#   DESCRIPTION: "
    echo "# "
    echo "#       OPTIONS: ---"
    echo "#  REQUIREMENTS: ---"
    echo "#          BUGS: ---"
    echo "#         NOTES: ---"
    echo "#        AUTHOR: linkscue(scue),"
    echo "#        MODIFY: nian0114"
    echo "#       CREATED: 2013年08月05日 03时04分29秒 HKT"
    echo "#       REBUILD: 2014年05月 1日 19时54分29秒 HKT"
    echo "#      REVISION:  ---"
    echo "#==============================================================================="

# fun: usage
usage(){
    echo
    echo "==> 联想K860/i boot recovery 解压、打包工具"
    echo
    echo -en "\e[0;31m" # color: red
    echo "==> 使用: $(basename $0) repack|unpack."
    echo -en "\e[0m"
    echo
}


self=$(readlink -f $0)
self_dir=self_dir=$(dirname $self)
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

    info "使用 bootimg.py 解压 $unpack_bootimage"
    $bootimg_tool --unpack-bootimg $unpack_bootimage
    info "去除 Ramdisk 多余首部信息"
    dd if=ramdisk of=ramdisk.gz bs=64 skip=1
    mv ramdisk ramdisk.bak
    if [[ -d root/ ]]; then
        test -d root.bak && \
            infosub "删除备份目录 root.bak" && \
            rm -rf root.bak 2>/dev/null
        infosub "备份 root/ 至 root.bak/"
        mv root root.bak
    fi
    mkdir root
    cd root
    info "解压 ramdisk.gz 至 root/ 目录"
    gzip -d -c ../ramdisk.gz | cpio -i
    cd -                                        # goto oldwd
    tip "解压 $unpack_bootimage 完成"

