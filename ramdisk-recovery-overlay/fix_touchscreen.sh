#!/system/bin/sh

mount /dev/block/mapper/vendor_a /mnt/vendor
mount -o bind /mnt/vendor /vendor
