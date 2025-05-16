# Ubuntu touch device tree ONLY FOR MIUI 12 (Xioami redmi note 8 2021)

## Compile guide

```bash
chmod +x build_auto.sh
./build_auto.sh <focal or noble>
```

Images output to images directory

### Compile output

boot.img - linux + halium initrd

rootfs.img - raw rootfs formated in ext4

system.img - rootfs.img converted to android sparse format

dtbo.img - dtbo prebulit

## Port to halium 12 - 13

Xioami don`t publish miui 13 - 14 kernel source for this device

## Flashing

Change slot to a

Install miui 14 and orangefox recovery

Reboot to orangefox

Format userdata

Flash miui 12 without flashing userdata part

Reboot to fastbootd mode

Flash system.img to system_a

Flash boot to boot_a
