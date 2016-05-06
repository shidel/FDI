#!/bin/sh

declare -a CFIND
declare -a CWITH
declare -a IPACKAGE
CCOUNT=0
ICOUNT=0

CANSKIP=Y

echox () {

    if [[ -f /bin/echo ]] ; then
        /bin/echo -n "${@}"
    else
        echo -n "${@}"
    fi

}

edit_variable () {

    read -e "${1}"

}

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
    echo "SRCDIR=\"${SRCDIR}\"">>"${CFG}"
    echo "DSTDIR=\"${DSTDIR}\"">>"${CFG}"
    echo "WRKDIR=\"${WRKDIR}\"">>"${CFG}"
    echo "CANSKIP=\"${CANSKIP}\"">>"${CFG}"
    echo >>"${CFG}"
    echo "ICOUNT=${ICOUNT}">>"${CFG}"
    local T=0
    while [[ $T -lt $ICOUNT ]] ; do
        echo "IPACKAGE[$T]=\"${IPACKAGE[$T]}\"">>"${CFG}"
        (( T++ ))
    done;
    echo >>"${CFG}"
    echo "CCOUNT=${CCOUNT}">>"${CFG}"
    local T=0
    while [[ $T -lt $CCOUNT ]] ; do
        echo "CFIND[$T]=\"${CFIND[$T]}\"">>"${CFG}"
        echo "CWITH[$T]=\"${CWITH[$T]}\"">>"${CFG}"
        (( T++ ))
    done;
}

check_settings () {

    local HWD="${PWD}"
    [[ ! -d "${SRCDIR}" ]] && SRCDIR=

    while ([[ "${SRCDIR}" == "" ]] || [[ ! -d "${SRCDIR}" ]]) ; do
        local t=
        local val=
        if [[ -f "BASE/COMMAND.ZIP" ]] ; then
            t="(${PWD})"
        fi;
        echo "Packages source directory${t}?"
        read -e val
        if [[ "${val}" == "" ]] && [[ "${t}" != "" ]] ; then
            SRCDIR="${PWD}"
        else
            [[ "${val}/BASE/COMMAND.ZIP" ]] && SRCDIR="${val}"
        fi;
        val=
        t=
        [[ "${SRCDIR}" != "" ]] && {
            cd "${SRCDIR}" && SRCDIR="${PWD}" || SRCDIR=
            cd "${HWD}"
        }
        [[ -d "${SRCDIR}" ]] && save_settings
    done;

    [[ "${DSTDIR}" != "" ]] && [[ ! -d "${DSTDIR}" ]] && mkdir -p "${DSTDIR}"
    [[ ! -d "${DSTDIR}" ]] && DSTDIR=
    while ([[ "${DSTDIR}" == "" ]] || [[ ! -d "${DSTDIR}" ]]) ; do
        local t="(${SRCDIR}/../OUTPUT)"
        local val=
        echo "Packages destination directory${t}?"
        read -e val
        if [[ "${val}" == "" ]] && [[ "${t}" != "" ]] ; then
            DSTDIR="${SRCDIR}/../OUTPUT"
        else
            [[ "${val}" ]] && DSTDIR="${val}"
        fi;
        [[ ! -d "${DSTDIR}" ]] && mkdir -p "${DSTDIR}"
        [[ ! -d "${DSTDIR}" ]] && DSTDIR=
        val=
        t=
        [[ "${DSTDIR}" != "" ]] && {
            cd "${DSTDIR}" && DSTDIR="${PWD}" || DSTDIR=
            cd "${HWD}"
        }
        [[ -d "${DSTDIR}" ]] && save_settings
    done;

    [[ "${WRKDIR}" != "" ]] && [[ ! -d "${WRKDIR}" ]] && mkdir -p "${WRKDIR}"
    [[ ! -d "${WRKDIR}" ]] && WRKDIR=
    while ([[ "${WRKDIR}" == "" ]] || [[ ! -d "${WRKDIR}" ]]) ; do
        local t="(${SRCDIR}/../TEMP)"
        local val=
        echo "Packages working directory${t}?"
        read -e val
        if [[ "${val}" == "" ]] && [[ "${t}" != "" ]] ; then
            WRKDIR="${SRCDIR}/../TEMP"
        else
            [[ "${val}" ]] && WRKDIR="${val}"
        fi;
        [[ ! -d "${WRKDIR}" ]] && mkdir -p "${WRKDIR}"
        [[ ! -d "${WRKDIR}" ]] && WRKDIR=
        val=
        t=
        [[ "${WRKDIR}" != "" ]] && {
            cd "${WRKDIR}" && WRKDIR="${PWD}" || WRKDIR=
            cd "${HWD}"
        }
        [[ -d "${WRKDIR}" ]] && save_settings
    done;

}

get_indent () {
    local T=$(grep -m 1 -i "^${2}:" "${1}" | tr -d "\r")
    INDENT=0
    while [[ "${T:${INDENT}:1}" != ":" ]] ; do
        (( INDENT++ ))
    done;
    (( INDENT++ ))
    while [[ "${T:${INDENT}:1}" == " " ]] ; do
        (( INDENT++ ))
    done;
    [[ $INDENT -lt $(( ${#2} + 2 )) ]] && (( INDENT++ ))
}

get_varaible () {

    local T=$(grep -m 1 -i "^${2}" "${1}" | tr -d "\r")
    echo ${T#*:}

}

set_varaible () {

    get_indent "${1}" "Copying-policy"
    cat "${1}" | tr -d '\r' | grep -B 1000 -i "^${2}" | grep -iv "^${2}" | tr -d '\r' >TEMPORARY.LSM
    local T=$(echo ${2:0:1} | tr "[:lower:]" "[:upper:]")$(echo ${2:1} | tr "[:upper:]" "[:lower:]")
    local T="${T}:                                 "
    echo "${T:0:$INDENT}${3}" | tr -d '\r' >>TEMPORARY.LSM
    cat "${1}" | tr -d '\r' | grep -A 1000 -i "^${2}" "${1}" | grep -iv "^${2}" | tr -d '\r'>>TEMPORARY.LSM
    mv TEMPORARY.LSM "${1}" || return 1

}

datestamp () {

    set_varaible "${1}" "Entered-date" "$(date +'%Y-%m-%d')"

}

ignore_package () {

    local C=0
    local PF=
    while [[ $C -lt $ICOUNT ]] && [[ "$PF" != "${1}" ]] ; do
        local PF="${IPACKAGE[$C]}"
        [[ "${PF}" == "${1}" ]] && {
            C=$CCOUNT
        }
        (( C++ ))
    done;

    [[ "${PF}" == "${1}" ]] && return 0 || return 1

}

read_package () {

    TITLE=$(get_varaible "${1}" title)
    VERSION=$(get_varaible "${1}" version)
    AUTHOR=$(get_varaible "${1}" author)
    POLICY=$(get_varaible "${1}" copying-policy)
    CPOLICY=

    [[ -d source ]] && SOURCES=Y || SOURCES=N

    local C=0
    local PC=$(echo ${POLICY} | tr "[:upper:]" "[:lower:]")
    while [[ $C -lt $CCOUNT ]] && [[ "$CPOLICY" == "" ]] ; do
        local PF=$(echo ${CFIND[$C]} | tr "[:upper:]" "[:lower:]")
        [[ "${PF}" == "${PC}" ]] && {
            CPOLICY=${CWITH[$C]}
            C=$CCOUNT
        }
        (( C++ ))
    done;

    [[ "$TITLE"   == "" ]] && return 1
    [[ "$VERSION" == "" ]] && return 1
    [[ "$AUTHOR"  == "" ]] && return 1
    [[ "$POLICY"  == "" ]] && return 1
    [[ "$CPOLICY"  == "" ]] && return 1
    [[ "$POLICY" != "$CPOLICY" ]] && return 1

    return 0
}

show_package () {

#    echo "Title:   $TITLE"
#    echo "Version: $VERSION"
#    echo "Author:  $AUTHOR"
#    echo "License: $POLICY"

    grep -B 1000 -i "^end" "${1}" | grep -A 1000 -i "^begin3" | grep -iv "^begin3\|^end"  # | sed  's/^/   /'
    [[ "$SOURCES" != "" ]] && {
        [[ "$SOURCES" == "N" ]] && SOURCES=Missing || SOURCES=Present
        get_indent "${1}" "title"
        [[ $INDENT -lt 15 ]] && INDENT=15
        local T="Source Files:                       "
        echo "${T:0:$INDENT}${SOURCES}"

    }
    echo

}

missing_data () {

    while [[ "${!2}" == "" ]] ; do
        show_package "${1}"
        [[ "$CANSKIP" == "Y" ]] && echox "Missing ${2} (enter to skip)?" || echox "Missing ${2}?"
        edit_variable "${2}"
        echo
        [[ "${!2}" == "" ]] && [[ "$CANSKIP" == "Y" ]] && {
            read_package "${1}"
            return 0
        }
        set_varaible "${1}" "${2}" "${!2}"
        read_package "${1}"
    done

}

check_policy () {

    while [[ "${CPOLICY}" == "" ]] ; do
        show_package "${1}"
        echox "Unknown copying policy \`${POLICY}' (enter to accept)?"
        edit_variable CPOLICY
        CPOLICY=$(echo "$CPOLICY" | tr -d "\r")
        [[ "${CPOLICY}" == "" ]] && CPOLICY="${POLICY}"
        CFIND[$CCOUNT]="${POLICY}"
        CWITH[$CCOUNT]="${CPOLICY}"
        (( CCOUNT++ ))
        echo
        save_settings
        set_varaible "${1}" "copying-policy" "${CPOLICY}"
        read_package "${1}"
    done
}

update_package () {

    ignore_package "${2}" && return 1

    local MODIFIED=N
    echo "Processing package ${2}"
    read_package "${1}" && {
        [[ "$SOURCES" == "N" ]] && {
            echo "Sources Missing. (press enter to continue)"
            read SOURCES
            SOURCES=
        }
        return 1
    }
    echo
    missing_data "${1}" "TITLE"
    missing_data "${1}" "VERSION"
    missing_data "${1}" "AUTHOR"
    # missing_data "${1}" "POLICY"

    local LATER=
    [[ "${CPOLICY}" != "" ]] && [[ "${CPOLICY}" != "${POLICY}" ]] && {
        local LATER="Copying-policy \`${POLICY}' updated to \`${CPOLICY}'"
        set_varaible "${1}" "copying-policy" "${CPOLICY}"
        read_package "${1}"
    }

    check_policy "${1}"

    datestamp "${1}"
    show_package "${1}"
    [[ "${LATER}" != "" ]] && {
        echo "${LATER}"
        echo
    }
    echox "Confirm (Y/n,i)?"
    read -n 1 MODIFIED
    echo
    [[ "${MODIFIED}" == "" ]] && MODIFIED=y
    [[ "${MODIFIED}" == [i/I] ]] && {
        echo "Ignore package ${2}"
        IPACKAGE[$ICOUNT]="${2}"
        (( ICOUNT++ ))
        save_settings
        return 1
    }
    [[ "${MODIFIED}" == [y/Y] ]] && {
        echo "Update package ${2}"
        return 0
    }
    return 1

}

process () {

    # [[ "${1%%/*}" != "BASE" ]] && return 0

    local PKG="${1##*/}"
    local PKG="${PKG%.*}"
    local HWD="${PWD}"
    cd "${WRKDIR}" || return 1
    [[ -d "${PKG}" ]] && {
        chmod -R 775 "${PKG}"
        rm -rf "${PKG}" || return 1
    }
    mkdir "${PKG}" || return 1
    cd "${PKG}" || return 1
    unzip -qq -L -o "${SRCDIR}/${1}" || return 1
    local LSM=$( echo "APPINFO/${PKG}.LSM" | tr "[:upper:]" "[:lower:]" )
    [[ ! -f "${LSM}" ]] && {
        echo "ERROR: unable to locate LSM for ${PKG}"
        return 1
    }
    update_package "${LSM}" "${1}" && {
        zip -9 -r -k -q "../${PKG}.ZIP" *
        unzip -qt "../${PKG}.ZIP" || return 1
        echo
        [[ ! -d "${DSTDIR}/${1%%/*}" ]] && {
            mkdir -p "${DSTDIR}/${1%%/*}" || return 1
        }
        mv "../${PKG}.ZIP" "${DSTDIR}/${1%%/*}" || return 1
    }
    cd ..
    [[ -d "${PKG}" ]] && {
        chmod -R 775 "${PKG}"
        rm -rf "${PKG}" || return 1
    }
    cd "${HWD}"

}

process_all () {

    local HWD="${PWD}"
    cd "${SRCDIR}"
    for PACKAGE in $(find '.' -name '*.ZIP' -o -name '*.zip') ; do
        process "${PACKAGE:2}" || {
            echo "ERROR: handling package ${PACKAGE:2}"
            exit 1
        }
    done
    cd "${HWD}"

}

load_settings
check_settings
process_all
save_settings