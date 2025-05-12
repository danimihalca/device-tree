#!/bin/bash

# this script load vendor modules

modules=(
kheaders.ko
wmt_drv.ko
bt_drv.ko
fmradio_drv.ko
gps_drv.ko
wmt_chrdev_wifi.ko
wlan_drv_gen4m.ko
fpsgo.ko
met.ko
udc_lib.ko
)

for module in "${modules[@]}"; do
    insmod -f "/vendor/lib/modules/$module"
done

echo 1 > /dev/wmtWifi

modprobe mi_memory

exit 0
