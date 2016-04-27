#!/bin/sh

check_dir () {

    [[ ! -d "$1" ]] && mkdir "$1"
    [[ ! -d "$1" ]] && {
        echo $1 build directory missing
        exit 1
    }
}

load_settings () {

    [[ -f "${0%.*}.cfg" ]] && {
        CFG="${0%.*}.cfg"
        . "${CFG}"
    }

    local T="${0%/*}"
    local T="${HOME}/${T%.*}.cfg"

    [[ -f "${T}" ]] && {
        CFG="${T}"
        . "${CFG}"
    }

}

save_settings () {

    echo "#!/bin/sh" >"${CFG}"
    echo >>"${CFG}"
    echo "SRCDIR=\"${SRCDIR}\"">>"${CFG}"
    echo "DSTDIR=\"${DSTDIR}\"">>"${CFG}"
    echo "WRKDIR=\"${WRKDIR}\"">>"${CFG}"

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
        read val
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
        read val
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
        read val
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

process () {

    local HWD="${PWD}"
    cd "${WRKDIR}"
    echo $1
    cd "${HWD}"

}

process_all () {

    local HWD="${PWD}"
    cd "${SRCDIR}"
    while read PACKAGE ; do
        process "${PACKAGE:2}"
    done<<<"$(find '.' -name '*.ZIP' -o -name '*.zip')"
    cd "${HWD}"

}

load_settings
check_settings
process_all