#!/bin/bash

choice_deviceinfo() {
    local deviceinfo_variant="$1"

    rm deviceinfo
    ln -s "deviceinfo-$deviceinfo_variant" deviceinfo
}

build_device_adaptations() {
    ./build.sh
}

build_ota_package() {
    local ota_output="$1"

    ./build/prepare-fake-ota.sh out/device_biloba_usrmerge.tar.xz "$ota_output"
}

build_flashable_images() {
    local ota_dir="$1"
    local images_output="$2"

    ./build/system-image-from-ota.sh "$ota_dir"/ubuntu_command "$images_output"
}
