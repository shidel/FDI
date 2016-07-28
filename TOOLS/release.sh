#!/bin/sh

check_dir () {

    [[ ! -d "$1" ]] && mkdir "$1"
    [[ ! -d "$1" ]] && {
        echo error creating $1 build directory
        exit 1
    }
}

load_config () {

    PROJECT=
    PREVIEW=
    FORMAT=
    FDI=
    SOURCE=
    OUTPUT=
    LABEL_FLOPPY=FLOPPY
    LABEL_SLIM=LITE
    LABEL_FULL=FULL

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

save_config () {

    echo "#!/bin/sh" >"${CFG}"
    echo >>"${CFG}"
    [[ "$PROJECT" != "" ]] && echo "PROJECT=\"${PROJECT}\"">>"${CFG}"
    echo "PREVIEW=\"${PREVIEW}\"">>"${CFG}"
    echo "FORMAT=\"${FORMAT}\"">>"${CFG}"
    # echo "FDI=\"${FDI}\"">>"${CFG}"
    echo >>"${CFG}"
    echo "SOURCE=\"${SOURCE}\"">>"${CFG}"
    echo "OUTPUT=\"${OUTPUT}\"">>"${CFG}"
    echo >>"${CFG}"
    echo "LABEL_FLOPPY=\"${LABEL_FLOPPY}\"">>"${CFG}"
    echo "LABEL_SLIM=\"${LABEL_SLIM}\"">>"${CFG}"
    echo "LABEL_FULL=\"${LABEL_FULL}\"">>"${CFG}"
}

check_config () {

    [[ "$PREVIEW" == "" ]] && {
        PREVIEW=yes
        save_config
    }

    [[ "$FORMAT" == "" ]] && {
        FORMAT=zip
        save_config
    }

    while [[ $(get_VBOX) ]] ; do
        echo Unable to locate the VirtualBox virtual machine files. Where is it?
        read -e SOURCE
        [[ $(get_VBOX) ]] && save_config
    done;

    while [[ ! -d "${OUTPUT}" ]] ; do
        echo Unable to locate the output base directory. Where is it?
        read -e OUTPUT
        [[ -d "${OUTPUT}" ]] && save_config
    done;

}

get_Random () {
    local HEX=0123456789abcdef
    local VAL=
    while [[ ${#VAL} -lt $1 ]] ; do
        local VAL="${VAL}${HEX:$(( RANDOM % 16 )):1}"
    done
    echo $VAL
}

get_VBOX () {
    [[ ! -d "${SOURCE}" ]] && return 1
    VBOX=$(ls "${SOURCE}/"*.vbox | head -n 1)
    [[ ! -f "${VBOX}" ]] && return 1
    return 0
}

get_XML () {
    cat "$VBOX" | grep -A 10000 -i "<${1}>" | grep -B 10000 -i "</${1}>"
}

get_UIDImage () {
    get_XML "MediaRegistry" | grep -i "uuid=\"{${1}}\"" | cut -d '"' -f 4
}

get_ImageUID () {
    grep -m 1 -i '<image uuid=' | cut -d '"' -f 2 | tr -d '{}'
}

get_FloppyUID () {
    get_XML "StorageControllers" | grep -A 1 -i 'type="floppy"' | grep -A 1 -i "device=\"$1\"" | get_ImageUID
}

get_HardDiskUID () {
    get_XML "StorageControllers" | grep -A 1 -i 'type="harddisk"' | grep -A 1 -i "port=\"$1\"" | grep -A 1 -i "device=\"$2\"" | get_ImageUID
}

get_VMDKImage () {
    [[ ! -f "$1" ]] && return 0
    grep -i "createType=\"monolithicFlat\"" "$1" >/dev/null || return 0
    grep -i "parentCID=ffffffff" "$1" >/dev/null || return 0
    local IMG=$(grep -i "^RW" "$1" | grep -i "FLAT" | cut -d '"' -f 2)
    [[ ! -f "${1%/*}/$IMG" ]] && return 0
    echo "${1%/*}/$IMG"
}

get_SizeImage () {
    [[ ! -f "$1" ]] && return 0
    local CYCL=$( grep -i "^ddb.geometry.bioscylinders" "$1" | cut -d '"' -f 2 | tr -d '"' )
    local HEAD=$( grep -i "^ddb.geometry.biosheads" "$1" | cut -d '"' -f 2 | tr -d '"')
    local SECT=$( grep -i "^ddb.geometry.biossectors" "$1" | cut -d '"' -f 2 | tr -d '"' )
    local SIZE=$( grep -i "^RW" "$1" | grep -i "FLAT" | cut -d ' ' -f 2 )
    [[ "${CYCL}" == "" ]] && return 0
    [[ "${HEAD}" == "" ]] && return 0
    [[ "${SECT}" == "" ]] && return 0
    [[ "${SIZE}" == "" ]] && return 0
    echo $(( ${CYCL} * ${HEAD} * $SECT / 2048 ))
}

get_DriveUIDs () {

    FD0_UID=$( get_FloppyUID 0 )
    FD1_UID=$( get_FloppyUID 1 )
    HDA_UID=$( get_HardDiskUID 0 0 )
    HDB_UID=$( get_HardDiskUID 0 1 )
    HDC_UID=$( get_HardDiskUID 1 0 )
    HDD_UID=$( get_HardDiskUID 1 1 )

    FD0_IMG=$( get_UIDImage "$FD0_UID" )
    FD1_IMG=$( get_UIDImage "$FD1_UID" )
    HDA_VMDK=$( get_UIDImage "$HDA_UID" )
    HDB_VMDK=$( get_UIDImage "$HDB_UID" )
    HDC_VMDK=$( get_UIDImage "$HDC_UID" )
    HDD_VMDK=$( get_UIDImage "$HDD_UID" )

    HDA_IMG=$( get_VMDKImage "${HDA_VMDK}" )
    HDB_IMG=$( get_VMDKImage "${HDB_VMDK}" )
    HDC_IMG=$( get_VMDKImage "${HDC_VMDK}" )
    HDD_IMG=$( get_VMDKImage "${HDD_VMDK}" )

    HDA_SIZE=$( get_SizeImage "${HDA_VMDK}" )
    HDB_SIZE=$( get_SizeImage "${HDB_VMDK}" )
    HDC_SIZE=$( get_SizeImage "${HDC_VMDK}" )
    HDD_SIZE=$( get_SizeImage "${HDD_VMDK}" )

}

make_Readme () {

    cp "${PWD}/README."* "$DEST" || {
        echo "error: failed to copy readme file"
        exit 1
    }

}
make_Floppy () {

    mkdir -p "$DEST/${PROJECT}${LABEL_FLOPPY}"
    cp "${FD0_IMG}" "$DEST/${PROJECT}${LABEL_FLOPPY}/${PROJECT}${LABEL_FLOPPY}.img" || {
        echo "error: failed to copy boot floppy image"
        exit 1
    }
    cp "${PWD}/README."* "$DEST/${PROJECT}${LABEL_FLOPPY}/" || {
        echo "error: failed to copy readme file"
        exit 1
    }

}

make_CDBoot () {

    cp "${FD1_IMG}" "$DEST/boot.img" || {
        echo "error: failed to copy CD-BOOT floppy image"
        exit 1
    }

}

set_VMDK_IMG () {

    grep -B 10000 -i "^RW " "$1"| grep -iv "^RW ">"${1%.*}.tmp"
    local LINE=$(grep -m 1 -i "^RW " "$1")
    local IMG=$(echo $LINE | cut -d '"' -f 1)"\"$2\""$(echo $LINE | cut -d '"' -f 3)
    echo "$IMG">>"${1%.*}.tmp"
    grep -A 10000 -i "^RW " "$1"| grep -iv "^RW ">>"${1%.*}.tmp"
    cp "${1%.*}.tmp" "$1"
    rm "${1%.*}.tmp"
}

set_VMDK_CID () {

    grep -B 10000 -i "^CID" "$1"| grep -iv "^CID">"${1%.*}.tmp"
    echo "CID=$(get_Random 8)">>"${1%.*}.tmp"
    grep -A 10000 -i "^CID" "$1"| grep -iv "^CID">>"${1%.*}.tmp"
    cp "${1%.*}.tmp" "$1"
    rm "${1%.*}.tmp"
}

filtered_VMDK () {

    grep -iv "^ddb.longContentID" | grep -iv "^ddb.uuid.image" | grep -iv "^ddb.uuid.modification" | grep -iv "^ddb.uuid "| grep -iv "^ddb.uuid="

}

make_USB () {

    local LABEL=LABEL_$1
    local LABEL=${!LABEL}
    mkdir -p "$DEST/${PROJECT}${LABEL}"
    local IMG=${2}_IMG
    local VMDK=${2}_VMDK
    cp "${!IMG}" "$DEST/${PROJECT}${LABEL}/${PROJECT}${LABEL}.img" || {
        echo "error: failed to ${LABEL} USB image"
        exit 1
    }
    local OUT="$DEST/${PROJECT}${LABEL}/${PROJECT}${LABEL}.vmdk"
    cat "${!VMDK}" | filtered_VMDK>"$OUT"
    set_VMDK_CID "$OUT"
    set_VMDK_IMG "$OUT" "${PROJECT}${LABEL}.img"
    cp "${PWD}/README."* "$DEST/${PROJECT}${LABEL}/" || {
        echo "error: failed to copy readme file"
        exit 1
    }

}

compress_all () {

    local HOLD="${PWD}"
    cd "${DEST}"
    for i in * ; do
        if [[ -d "$i" ]] ; then
            cd "$i"
            [[ "$FORMAT" == "zip" ]] && zip -9 -r "../${i}.zip" *
            [[ "$FORMAT" == "tgz" ]] && tar -cvzf "../${i}.tgz" *
            [[ "$FORMAT" == "tbz" ]] && tar -cvjf "../${i}.tbz" *
            cd "${DEST}"
            rm -rf "$i"
        fi

    done

    cd "$HOLD"

}

create_release () {

    RELEASE=0
    TODAY=$(date +'%Y-%m-%d')
    # TODAY=$(date +'%y.%m.%d')

    load_config
    check_config

    [[ "$PROJECT" == "" ]] && PROJECT=$(echo "${PWD##*/}")

    get_VBOX
    get_DriveUIDs

    if [[ "$HDB_IMG" != "" ]] && [[ "$HDC_IMG" != "" ]] ; then
        [[ $HDB_SIZE -lt $HDC_SIZE ]] && {
            SLIM=HDB
            FULL=HDC
        } || {
            SLIM=HDC
            FULL=HDB
        }
    elif [[ "$HDB_IMG" != "" ]] ; then
        SLIM=
        FULL=HDB
    elif [[ "$HDB_IMG" != "" ]] ; then
        SLIM=
        FULL=HDC
    else
        echo "error: unable to locate USB images"
        exit 1
    fi;

    echo FreeDOS based project \`$PROJECT\' release deployment${MORE}.

    echo
    echo "  Virtual Machine:   $VBOX"
    echo
    [[ "$FD0_IMG" != "" ]] && echo "  Builder (HDA):     $HDA_UID, ${HDA_IMG//${SOURCE}/.}, ${HDA_SIZE}MB"
    echo
    [[ "$FD0_IMG" != "" ]] && echo "  BOOT Floppy (FD0): $FD0_UID, ${FD0_IMG//${SOURCE}/.}"
    [[ "$FD0_IMG" != "" ]] && echo "  BOOT CD-ROM (FD1): $FD1_UID, ${FD1_IMG//${SOURCE}/.}"

    [[ "$HDB_IMG" != "" ]] && {
        [[ "$SLIM" == "HDB" ]] && local TYPE=$LABEL_SLIM || local TYPE=$LABEL_FULL
        echo "  USB $TYPE (HDB):    $HDB_UID, ${HDB_IMG//${SOURCE}/.}, ${HDB_SIZE}MB"
    }

    [[ "$HDC_IMG" != "" ]] && {
        [[ "$SLIM" == "HDC" ]] && local TYPE=$LABEL_SLIM || local TYPE=$LABEL_FULL
        echo "  USB $TYPE (HDC):    $HDC_UID, ${HDC_IMG//${SOURCE}/.}, ${HDC_SIZE}MB"
    }

    DEST="${OUTPUT}/${PROJECT}-${TODAY}"
    while [[ -e "$DEST" ]] ; do
        (( RELEASE++ ))
        DEST="${OUTPUT}/${PROJECT}-${TODAY}-${RELEASE}"
    done

    mkdir -p "$DEST" || {
        echo "error: unable to make project release directory \`$DEST'"
    }

    echo
    echo "  OUTPUT PATH:       $DEST"

    make_Readme
    [[ "$FD0_IMG" != "" ]] && make_Floppy
    [[ "$FD1_IMG" != "" ]] && make_CDBoot
    [[ "$SLIM" != "" ]] && make_USB SLIM $SLIM
    [[ "$FULL" != "" ]] && make_USB FULL $FULL

    compress_all

}

create_release