FROM ubuntu:22.04
# ubuntu 22.04 is last supported version with python2 in repos

RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends python2 android-tools-mkbootimg bc bison build-essential ca-certificates cpio curl fakeroot flex git kmod libssl-dev libtinfo5 sudo unzip wget xz-utils img2simg jq && \
    ln -sf python2.7 /usr/bin/python && \
    wget https://raw.githubusercontent.com/LineageOS/android_system_core/lineage-17.1/mkbootimg/mkbootimg.py -O /usr/bin/mkbootimg
