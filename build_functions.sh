#!/bin/bash

build_image() {
    local image_tag="$1"

    # Build image only if image don`t exists
    if [ -z "$(sudo docker images -q $image_tag)" ]; then
        sudo docker build . -t "$image_tag"
    fi
}

run_command_in_container() { # create container based on ut-biloba-build image and run command from $1
    local command="$1"

    sudo docker run --rm -ti -v "${PWD}:/device-tree" \
           -w /device-tree \
           ut-biloba-build bash -c "$command"
}

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

    sudo ./build/system-image-from-ota.sh "$ota_dir"/ubuntu_command "$images_output"
}
