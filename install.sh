#!/bin/bash
path=$0
dir=$(dirname "$path")
cd "$dir" || exit 1
ANDROID_NUM=8
MANAGE_SEHLL_DIR=/userdata/arm-agent/bin/manage-shell

install_for_linux(){
    chmod +x android_dev_prepare*.sh
    cp android_dev_prepare*.sh /usr/bin/
    cp android_dev_prepare.service /usr/lib/systemd/system/
    systemctl daemon-reload
    sudo systemctl start android_dev_prepare
    sudo systemctl enable android_dev_prepare
}

install_for_android(){
    echo "#!/system/bin/sh" > ./dev_prepare.sh
    cat ./android_dev_prepare.sh >> ./dev_prepare.sh
    chmod +x ./dev_prepare.sh
    rsync ./dev_prepare.rc $MANAGE_SEHLL_DIR/mount/default/system/etc/init/
    rsync ./dev_prepare.sh $MANAGE_SEHLL_DIR/mount/default/system/xbin/
    for((id=0;id<ANDROID_NUM;id++)); do
        # 移动脚本和rc文件
        if [ -d $MANAGE_SEHLL_DIR/mount/$id ]; then
            rsync ./dev_prepare.rc $MANAGE_SEHLL_DIR/mount/$id/system/etc/init/
            rsync ./android_dev_prepare.sh $MANAGE_SEHLL_DIR/mount/$id/system/xbin/
        fi
        # 将volums添加到docker-compose.yml
        local local_rc_dir="./mount/$id/system/etc/init/dev_prepare.rc"
        local container_rc_dir="/system/etc/init/dev_prepare.rc"
        $MANAGE_SEHLL_DIR/sh/add_volume.sh "$id" "$local_rc_dir" "$container_rc_dir"
        local local_sh_dir="./mount/$id/system/xbin/dev_prepare.sh"
        local container_sh_dir="/system/xbin/dev_prepare.sh"
        $MANAGE_SEHLL_DIR/sh/add_volume.sh "$id" "$local_sh_dir" "$container_sh_dir"
    done
}


install_for_linux
if [ -f "/userdata/arm-agent/bin/manage-shell/sh/add_volume.sh" ]; then
    install_for_android
else
    echo Error: Please check you manage-shell verison, it must be greater than 1.0.7
fi