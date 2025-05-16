# This script builds all variants

#!/bin/bash

source build_functions.sh

echo "------BUILDING DEVICE ADPATATIONS------"

choice_deviceinfo "focal"
build_device_adaptations

echo "------BUILDING FOCAL IMAGES------"

# Build focal images

build_ota_package ota_focal
build_flashable_images ota_focal images_focal

echo "------BUILDING NOBLE IMAGES------"

# Build noble images

choice_deviceinfo "noble"
build_ota_package ota_noble
build_flashable_images ota_noble images_noble
