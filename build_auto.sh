#!/bin/bash

local build_variant = "$1"

source build_functions.sh

choice_deviceinfo "$build_variant"
build_device_adaptations
build_ota_package ota
build_flashable_images ota images
