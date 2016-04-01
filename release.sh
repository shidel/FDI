#!/bin/sh


PRERELEASE='.pre'

DESTINATION='Downloads'

RELEASE=0
PROJECT=$(echo ${PWD##*/})
TODAY=$(date +'%Y-%m-%d')
# TODAY=$(date +'%y.%m.%d')

[[ "$1" == "" ]] && FORMAT=zip || FORMAT=$1

[[ -d "${HOME}/${DESTINATION}/${PROJECT}" ]] && rm -rf "${HOME}/${DESTINATION}/${PROJECT}"

# mkdir -p "${HOME}/${DESTINATION}/${PROJECT}"
# cp -r * "${HOME}/${DESTINATION}/${PROJECT}/"
# rm -f "${HOME}/${DESTINATION}/${PROJECT}/"*.sh

mkdir -p "${HOME}/${DESTINATION}/${PROJECT}"
cp -r "${HOME}/Documents/Virtual Machines.localized/FDI.img" "${HOME}/${DESTINATION}/${PROJECT}/"

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

rm "${HOME}/${DESTINATION}/${PROJECT}-USB."* >/dev/null
rm "${HOME}/${DESTINATION}/${PROJECT}-SLIM."* >/dev/null

CURDIR="$PWD"

cd "${HOME}/${DESTINATION}"
cp "${HOME}/Documents/Virtual Machines.localized/Platforms/Development/FDI Builder.vmwarevm/USB-512MB-flat.vmdk" "${HOME}/${DESTINATION}/${PROJECT}-USB.img"
cat "${HOME}/Documents/Virtual Machines.localized/Platforms/Development/FDI Builder.vmwarevm/USB-512MB.vmdk" | sed 's/USB-512MB-flat.vmdk/FDI-USB.img/g' >"${HOME}/${DESTINATION}/${PROJECT}-USB.vmdk"
zip -9 -r "${PROJECT}-USB.zip" "${PROJECT}-USB.img" "${PROJECT}-USB.vmdk"
cp "${HOME}/Documents/Virtual Machines.localized/Platforms/Development/FDI Builder.vmwarevm/USB-32MB-flat.vmdk" "${HOME}/${DESTINATION}/${PROJECT}-SLIM.img"
cat "${HOME}/Documents/Virtual Machines.localized/Platforms/Development/FDI Builder.vmwarevm/USB-32MB.vmdk" | sed 's/USB-32MB-flat.vmdk/FDI-SLIM.img/g' >"${HOME}/${DESTINATION}/${PROJECT}-SLIM.vmdk"
zip -9 -r "${PROJECT}-SLIM.zip" "${PROJECT}-SLIM.img" "${PROJECT}-SLIM.vmdk"

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
