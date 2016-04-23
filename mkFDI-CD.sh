#!/bin/sh

checkdir () {

    [[ ! -d "$1" ]] && mkdir "$1"
    [[ ! -d "$1" ]] && {
        echo $1 build directory missing
        exit 1
    }

}

FLOPPY=

for i in FDI-20*.zip ; do
    [[ -f $i ]] && FLOPPY=$i
done;

[[ -f "FDI.img" ]] && FLOPPY=FDI.img

[[ "$FLOPPY" == "" ]] && {
    echo FDI floppy zip archive missing
    exit 1
}

[[ ! -f FDI-USB.zip ]] && {
    echo FDI USB zip archive missing
    exit 1
}

checkdir "$HOME/FDI"
checkdir "/mnt/FDI"
checkdir "$HOME/FDI/CDROM"
checkdir "$HOME/FDI/CDROM/PKGINFO"

unzip -o FDI-USB.zip -d "$HOME/FDI"

if [[ "${FLOPPY##*.}" == "zip" ]] ; then
    unzip -o "${FLOPPY}" -d "$HOME/FDI"
    cp "$HOME/FDI/FDI/"* "$HOME/FDI"
    rm -rf "$HOME/FDI/FDI"
else
    cp "${FLOPPY}" "$HOME/FDI"
fi;

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
cp -v  "$HOME/FDI/FDI.img" "$HOME/FDI/CDROM/boot.img"

umount /mnt/FDI

HERE="$PWD"

cd "$HOME/FDI/CDROM"
mkisofs -V FDI-CD -r -b boot.img -c boot.cat -o "$HERE/FDI-CD.iso" .

cd "$HERE"
rm -rf "$HOME/FDI"