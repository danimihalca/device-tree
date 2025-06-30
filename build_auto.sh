# $1 - is deviceinfo variant

#!/bin/bash

source build_functions.sh

build_image ut-biloba-build

sudo rm -rdf build images ota out

run_command_in_container "source build_functions.sh && choice_deviceinfo $1 && build_device_adaptations && build_ota_package ota && build_flashable_images ota images"
