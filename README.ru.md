# Дерево для ubuntu touch ТОЛЬКО ДЛЯ MIUI 12 (Xioami redmi note 8 2021)

## Инструкция по сборке

```bash
chmod +x build_auto.sh
./build_auto.sh <focal or noble>
```

Результат сохраняется в директорию images.

### Сборка образов из пребилдов адаптаций (без компиляции ядра)

```bash
[ -d build ] || git clone https://gitlab.com/ubports/community-ports/halium-generic-adaptation-build-tools -b main build # Клонирует репозиторий с сборочными скриптами если те не склонированы
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://codeberg.org/Biloba-UT/prebuilds.git # Клонирует репозиторий с пребилдами без образов для прошивки
mv prebuilds/device_adaptations out
rm -rdf prebuilds
source build_functions.sh
choice_deviceinfo <focal or noble>
build_ota_package ota
build_flashable_images ota images # Конвертирует ota пакет в образы для прошивки
```

### Результат сборки

boot.img — linux + halium initrd

rootfs.img — сырой root файловой системы в формате ext4

system.img — rootfs.img преобразован в формат android sparse format

dtbo.img - dtbo из miui

## Назначение сборочных скриптов

build_auto.sh - собирает адаптации, ota и образы для варианта из первого аргумента.

build_ci.sh - собирает адаптации, ota и образы для всех возможных вариантов.

## Прошивка

Для начала нужно скачать [пребилды](https://codeberg.org/Biloba-UT/prebuilds): images-0 это 20.04, images_noble это 24.04(тестовый нестабильный плохой другие синонимы сюда). или [собрать прошивку самому](#Инструкция-по-сборке)

После этого нужно прошить стоковую версию V12.5.9.0.RCUMIXM начисто (flash_all).

Затем необходимо перезагрузиться в загрузчик (отключите телефон и зажмите кнопку громкости вниз и кнопку питания, пока не появится надпись fastboot). После этого отпустите кнопки, и запустите комманду fastboot reboot fastboot

Потом запустите эти комманды в терминале (в той директории куда вы скачивали пребилды):

```bash
fastboot flash dtbo dtbo.img
fastboot flash boot boot.img
fastboot flash system system.img
fastboot reboot bootloader
```

Подождите пока не появиться надпись fastboot и запустите комманду fastboot reboot recovery

Когда телефон загрузится в recovery, нужно протапать 'Factory reset' -> 'Format data/factory reset' -> 'Format data'. После этого просто перезагрузите телефон.
