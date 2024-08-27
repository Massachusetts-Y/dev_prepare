rm -rf /dev/nvme0*
rm -rf /dev/mapper
rm -rf /dev/mtd*
rm -rf /dev/tee*
rm -rf /dev/block
rm -rf /dev/media*
rm -rf /dev/watchdog*


prepare_block(){
    if mount | grep -q /sys/dev/block; then
        return 0;
    fi
    rm -rf /data/local/tmp/char

    mkdir -p /data/local/tmp/block
    mount -o bind /data/local/tmp/block /sys/dev/block
}

prepare_char(){
    if mount | grep -q /sys/dev/char; then
        return 0;
    fi
    rm -rf /data/local/tmp/char
    mkdir -p /data/local/tmp/char

    cd /data/local/tmp/char
    ln -s ../../devices/virtual/mem/mem 1:1
    ln -s ../../devices/virtual/mem/kmsg 1:11
    ln -s ../../devices/virtual/mem/null 1:3
    ln -s ../../devices/virtual/mem/port 1:4
    ln -s ../../devices/virtual/mem/zero 1:5
    ln -s ../../devices/virtual/mem/full 1:7
    ln -s ../../devices/virtual/mem/random 1:8
    ln -s ../../devices/virtual/mem/urandom 1:9
    cd - >/dev/null 2>&1
    mount -o bind /data/local/tmp/char /sys/dev/char
}


prepare_block
prepare_char

