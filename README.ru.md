# Дерево для ubuntu touch ТОЛЬКО ДЛЯ MIUI 12 (Xioami redmi note 8 2021)

## Инструкция по сборке

```bash
chmod +x build_auto.sh
./build_auto.sh <focal or noble>
```

Результат сохраняется в директорию images

### Результат сборки

boot.img - linux + halium initrd

rootfs.img - сырой rootfs в файловой системе ext4

system.img - rootfs.img converted to android sparse format

system.img - rootfs.img сконфертированый в android sparse format

dtbo.img - dtbo из miui

## Назначение сборочных скриптов

build_auto.sh - собирает адаптации, ota и images для варианта из первого аргумента

build_ci.sh - собирает адаптации, ota и images для всех возможных вариантов

## Прошивка

Для начала нужно скачать [пребилды](https://codeberg.org/Biloba-UT/prebuilds) images-0 это 20.04, images_noble это 24.04(тестовый нестабильный плохой другие синонимы сюда) или [собрать прошивку самому](#Инструкция-по-сборке)

После нужно прошить сток версии V12.5.9.0.RCUMIXM начисто (flash_all).

После нужно презагрузится в загрушик (Отключить телефон и зажать кнопку громкости вниз и кнопку питание пока не появиться надпись fastboot, потом разумется перестать зажимать кнопки) и запустить комманду fastboot reboot fastboot

Потом запустить эти комманды в терминале (в той директории куда вы скачивали пребилды):

```bash
fastboot flash dtbo dtbo.img
fastboot flash boot boot.img
fastboot flash system system.img
fastboot reboot bootloader
```

Подожтите пока не появиться надпись fastboot и запустите комманду fastboot reboot recovery

Когда телефон загрузется в recovery, нужно протапать это 'Factory reset' -> 'Format data/factory reset' -> 'Format data', после просто перезагрузить телефон
