#!/bin/sh

FLOPPY=FDI.img
USB=FDI-USB.img

check_dir () {

    [[ ! -d "$1" ]] && mkdir "$1"
    [[ ! -d "$1" ]] && {
        echo $1 build directory missing
        exit 1
    }
}

load_settings () {

    local BASE="${0##*/}"
    local BASE="${BASE%.*}"

    [[ -f "${PWD}/${BASE}.cfg" ]] && {
        CFG="${PWD}/${BASE}.cfg"
        . "${CFG}"
    }

    local T="${HOME}/${BASE}.cfg"

    [[ -f "${T}" ]] && {
        CFG="${T}"
        . "${CFG}"
    }

    [[ "${CFG}" == "" ]] && {
        CFG="${PWD}/${BASE}.cfg"
        echo >"${CFG}"
    }

}

save_settings () {

    echo "#!/bin/sh" >"${CFG}"
    echo >>"${CFG}"
    echo "FLOPPY=\"${FLOPPY}\"">>"${CFG}"
    echo "USB=\"${USB}\"">>"${CFG}"

}

check_settings () {

    while [[ ! -f "${FLOPPY}" ]]; do
        echo Unable to locate El Torito Floppy image. Where is it?
        read -e FLOPPY
        [[ -f "${FLOPPY}" ]] && save_settings
    done;
    while [[ ! -f "${USB}" ]]; do
        echo Unable to locate USB image. Where is it?
        read -e USB
        [[ -f "${USB}" ]] && save_settings
    done;

}


load_settings
check_settings

check_dir "$HOME/FDI"
check_dir "/mnt/FDI"
check_dir "$HOME/FDI/CDROM"

check_dir "$HOME/FDI/CDROM/PKGINFO"

cp -v "${FLOPPY}" "$HOME/FDI"
cp -v "${USB}" "$HOME/FDI/FDI-USB.img"

START=
for i  in $(fdisk -l "$HOME/FDI/FDI-USB.img" | grep .img1 | cut -d '*' -f 2); do
    [[ "$START" == "" ]] && START=$i
done

[[ "$START" == "" ]] && {
    echo unable to parse USB image data.
    exit 1
}

mount -o loop,offset=$(( $START * 512 )) "$HOME/FDI/FDI-USB.img" "/mnt/FDI" || {
    echo unable to mount USB image.
    exit 1
}

cp -rv /mnt/FDI/FDSETUP/PACKAGES/* "$HOME/FDI/CDROM"
cp -r  /mnt/FDI/FDSETUP/PKGINFO/* "$HOME/FDI/CDROM/PKGINFO/"

## cp -rv  /mnt/FDI/* "$HOME/FDI/CDROM"

cp -v  "$HOME/FDI/FDI.img" "$HOME/FDI/CDROM/boot.img"

umount /mnt/FDI

HERE="$PWD"

cd "$HOME/FDI/CDROM"
mkisofs -V FDI-CD -r -b boot.img -c boot.cat -o "$HERE/FDI-CD.iso" .

cd "$HERE"
rm -rf "$HOME/FDI"