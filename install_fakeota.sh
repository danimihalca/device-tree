#!/bin/bash

wait_device() { # This function wait device in recovery and check if this ubports recovery
    adb wait-for-recovery
    if [[ $(adb shell getprop ro.ubuntu.recovery) != "true" ]];
    then
       echo "Error: device in recovery detected, but is not ubports recovery"
       exit
    fi
}

wipe_userdata() { # Write format data to ubuntu_command and reboot device to recovery
    echo "format data" > /tmp/ubuntu_command
    adb push /tmp/ubuntu_command /cache/recovery
    rm /tmp/ubuntu_command
    adb reboot recovery
}

disable_signature_verify() { # This function temp disable ota updates verifying
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    git checkout debug_disable_signature_verification

    adb shell rm /sbin/system-image-upgrader /system/bin/system-image-upgrader
    adb push ramdisk-recovery-overlay/sbin/system-image-upgrader /sbin
    adb shell ln -sf /sbin/system-image-upgrader /system/bin
    adb shell chmod +x /sbin/system-image-upgrader /system/bin/system-image-upgrader

    git checkout "$current_branch"
}

push_and_install_ota() {
    ota_dir="$1"

    update_command="cd /cache/recovery && system-image-upgrader ubuntu_command"

    adb push "$ota_dir"/* /cache/recovery/
    adb shell "$update_command"
}

echo "DEPRECATION WARNING: install_fakeota.sh replaced by install_fakeota.py"

if [[ "$1" == "" ]];
then
   echo "Put ota path to first argument!"
   exit
fi

wait_device
disable_signature_verify
push_and_install_ota "$1"
wipe_userdata
