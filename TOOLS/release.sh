#!/bin/sh


PRERELEASE='.pre'
DESTINATION='Downloads'

SOURCE=
FLOPPY=FLOPPY.img
ELTORITO=FDI.img
SUSB=FDI-SLIM.img
BUSB=FDI-USB.img

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
    echo "SOURCE=\"${SOURCE}\"">>"${CFG}"
    echo "PRERELEASE=\"${PRERELEASE}\"">>"${CFG}"
    echo "DESTINATION=\"${DESTINATION}\"">>"${CFG}"
    echo "FLOPPY=\"${FLOPPY}\"">>"${CFG}"
    echo "ELTORITO=\"${ELTORITO}\"">>"${CFG}"
    echo "SUSB=\"${SUSB}\"">>"${CFG}"
    echo "BUSB=\"${BUSB}\"">>"${CFG}"

}

check_settings () {

    while [[ ! -d "${SOURCE}" ]]; do
        echo Unable to locate virtual machine files. Where is it?
        read -e SOURCE
        [[ -d "${SOURCE}" ]] && save_settings
    done;

    while [[ ! -f "${SOURCE}/${FLOPPY}" ]]; do
        echo Unable to locate normal floppy image. Where is it?
        read -e FLOPPY
        [[ -f "${SOURCE}/${FLOPPY}" ]] && save_settings
    done;
    while [[ ! -f "${SOURCE}/${ELTORITO}" ]]; do
        echo Unable to locate El Torito Floppy image. Where is it?
        read -e ELTORITO
        [[ -f "${SOURCE}/${ELTORITO}" ]] && save_settings
    done;
    while [[ ! -f "${SOURCE}/${SUSB}" ]]; do
        echo Unable to locate SLIM USB image. Where is it?
        read -e SUSB
        [[ -f "${SOURCE}/${SUSB}" ]] && save_settings
    done;
    while [[ ! -f "${SOURCE}/${BUSB}" ]]; do
        echo Unable to locate FULL USB image. Where is it?
        read -e BUSB
        [[ -f "${SOURCE}/${BUSB}" ]] && save_settings
    done;

}

load_settings
check_settings

RELEASE=0
PROJECT=$(echo ${PWD##*/})
TODAY=$(date +'%Y-%m-%d')
# TODAY=$(date +'%y.%m.%d')

[[ "$1" == "" ]] && FORMAT=zip || FORMAT=$1

[[ -d "${HOME}/${DESTINATION}/${PROJECT}" ]] && rm -rf "${HOME}/${DESTINATION}/${PROJECT}"

rm "${HOME}/${DESTINATION}/${PROJECT}-USB"*.${FORMAT} >/dev/null
rm "${HOME}/${DESTINATION}/${PROJECT}-SLIM"*.${FORMAT} >/dev/null

mkdir -p "${HOME}/${DESTINATION}/${PROJECT}"
cp -r "${SOURCE}/${FLOPPY}" "${HOME}/${DESTINATION}/${PROJECT}/FDI.img"

ARCHIVE="${PROJECT}-${TODAY}-${RELEASE}${PRERELEASE}.${FORMAT}"
while [[ -f "${HOME}/${DESTINATION}/${ARCHIVE}" ]] ; do
	(( RELEASE++ ))
	ARCHIVE="${PROJECT}-${TODAY}-${RELEASE}${PRERELEASE}.${FORMAT}"
done

echo "${HOME}/${DESTINATION}/${ARCHIVE}"

if [[ -f 'README.txt' ]] ; then
	cp 'README.txt' "${HOME}/${DESTINATION}/${PROJECT}-README.txt"
	cp 'README.txt' "${HOME}/${DESTINATION}/${PROJECT}/README.txt"
fi;

if [[ -f 'README.md' ]] ; then
	cp 'README.md' "${HOME}/${DESTINATION}/${PROJECT}-README.md"
	cp 'README.md' "${HOME}/${DESTINATION}/${PROJECT}/README.md"
fi;

CURDIR="$PWD"

cd "${HOME}/${DESTINATION}"
cp "${SOURCE}/${SUSB}" "${HOME}/${DESTINATION}"
cp "${SOURCE}/${SUSB%.*}.vmdk" "${HOME}/${DESTINATION}"
zip -9 -r "${PROJECT}-SLIM.zip" "${PROJECT}-SLIM.img" "${PROJECT}-SLIM.vmdk"
cp "${SOURCE}/${BUSB}" "${HOME}/${DESTINATION}"
cp "${SOURCE}/${BUSB%.*}.vmdk" "${HOME}/${DESTINATION}"
zip -9 -r "${PROJECT}-USB.zip" "${PROJECT}-USB.img" "${PROJECT}-USB.vmdk"

rm "${HOME}/${DESTINATION}/${PROJECT}-"*.img >/dev/null
rm "${HOME}/${DESTINATION}/${PROJECT}-"*.vmdk >/dev/null

cd "${CURDIR}"

CURDIR="$PWD"
cd "${HOME}/${DESTINATION}"
[[ "$FORMAT" == "zip" ]] && zip -9 -r "${ARCHIVE}" "${PROJECT}/"*
[[ "$FORMAT" == "tgz" ]] && tar -cvzf "${ARCHIVE}" "${PROJECT}/"*
[[ "$FORMAT" == "tbz" ]] && tar -cvjf "${ARCHIVE}" "${PROJECT}/"*
cd "${CURDIR}"

rm -rf "${HOME}/${DESTINATION}/${PROJECT}"
