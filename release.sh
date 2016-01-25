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

cp "${HOME}/Documents/Virtual Machines.localized/Platforms/Development/FDI Builder.vmwarevm/Virtual Disk-flat.vmdk" "${HOME}/${DESTINATION}/${PROJECT}-USB.img"
zip -9 -r "${HOME}/${DESTINATION}/${PROJECT}-USB.zip" "${HOME}/${DESTINATION}/${PROJECT}-USB.img"

CURDIR="$PWD"
cd "${HOME}/${DESTINATION}"
[[ "$FORMAT" == "zip" ]] && zip -9 -r "${ARCHIVE}" "${PROJECT}/"*
[[ "$FORMAT" == "tgz" ]] && tar -cvzf "${ARCHIVE}" "${PROJECT}/"*
[[ "$FORMAT" == "tbz" ]] && tar -cvjf "${ARCHIVE}" "${PROJECT}/"*
cd "${CURDIR}"

rm -rf "${HOME}/${DESTINATION}/${PROJECT}"
