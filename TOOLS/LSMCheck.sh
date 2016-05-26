#!/bin/sh

value () {
    echo $(cat "$1" | grep -i "^$2" | cut -d ':' -f 2- | tr -d "[:special:]" | tr -d "[:cntrl:]" )
}

setvalue () {

    grep -B 1000 -i "^$2" "$1" | grep -iv "^$2" >TEMPORARY.LSM
    local line=$(grep -i "^$2" "$1" | tr -d "[:special:]" | tr -d "[:cntrl:]")
    local var=0
    local flg=y
    while [[ "$flg" == "y" ]] && [[ $var -lt ${#line} ]] ; do
        [[ "${line:$var:1}" == ":" ]] && flg=s
        (( var++ ))
    done
    while [[ "$flg" != "" ]] && [[ $var -lt ${#line} ]] ; do
        [[ "${line:$var:1}" == " " ]] && (( var++ )) || flg=
    done
    (( var-- ))
    echo "${line:0:$var}" "$3">>TEMPORARY.LSM
    grep -A 1000 -i "^$2" "$1" | grep -iv "^$2" >>TEMPORARY.LSM
    cp TEMPORARY.LSM "$1" >/dev/null
    rm TEMPORARY.LSM >/dev/null
}

TOP="$PWD"

NEWP="$TOP/FD12"
OLDP="$TOP/FD11"

cd "$OLDP"
[[ "${1}" == "" ]] && FILTER=".ZIP" || FILTER=${1}
for i in $(find . -name '*.ZIP' -o -name '*.zip' | grep -i '.ZIP' | grep -i "$FILTER") ; do
    PKG="${i##*/}"
    NAME="${PKG%.*}"

    NEW=$(find "$NEWP" -name "*" | grep -i "/$PKG")
    if [[ -f "$NEW" ]] ; then
        cd "$OLDP/${i%/*}"
        fdpkg.sh "$PKG">/dev/null
        OVER="$(value $NAME/APPINFO/$NAME.LSM version)"
        OENT="$(value $NAME/APPINFO/$NAME.LSM entered-date)"
        OLIC="$(value $NAME/APPINFO/$NAME.LSM copying-policy)"
        OVAL=$(find "$NAME" | md5)
        fdpkg.sh "$NAME" >/dev/null
        cd "${NEW%/*}"
        PKG="${NEW##*/}"
        NAME="${PKG%.*}"
        fdpkg.sh "$PKG" >/dev/null
        NVAL=$(find "$NAME" | md5)
        NVER="$(value $NAME/APPINFO/$NAME.LSM version)"
        NENT="$(value $NAME/APPINFO/$NAME.LSM entered-date)"
        NLIC="$(value $NAME/APPINFO/$NAME.LSM copying-policy)"

        [[ "$NVAL" != "$OVAL" ]] && NVAL=" (modified files)" || NVAL=
        if [[ "$OVER" != "$NVER" ]] ; then
            [[ "$OLIC" != "$NLIC" ]] && {
                echo "$NAME, $OVER --> $NVER $NVAL"
                echo "  $OLIC --> $NLIC"
            } || {
                echo "$NAME, $OVER --> $NVER ($NLIC) $NVAL"
            }
            [[ "$OENT" == "$NENT" ]] && {
                NENT=$(date +'%Y-%m-%d')
                setvalue $NAME/APPINFO/$NAME.LSM entered-date "$NENT"
                echo "  $OENT --> $NENT"
            }
        elif  [[ "$OENT" != "$NENT" ]] ; then
            echo "Fix entered-date for $NAME to $OENT. $NVAL"
            setvalue $NAME/APPINFO/$NAME.LSM entered-date "$OENT"
        elif [[ "$NVAL" != "" ]] ; then
            echo "Note $NAME. $NVAL"
        elif [[ "$NVER" == "" ]] ; then
             echo "error: $NAME, $NVER, $NENT, ($NLIC)"
        elif [[ "$NENT" == "" ]] ; then
             echo "error: $NAME, $NVER, $NENT, ($NLIC)"
        elif [[ "$NLIC" == "" ]] ; then
             echo "error: $NAME, $NVER, $NENT, ($NLIC)"
        fi

        fdpkg.sh "$NAME" >/dev/null
        cd "$OLDP"
    fi
done

cd "$NEWP"
for i in $(find . -name '*.ZIP' -o -name '*.zip' | grep -i '.ZIP' | grep -i "$FILTER") ; do
    PKG="${i##*/}"
    NAME="${PKG%.*}"

    NEW=$(find "$OLDP" -name "*" | grep -i "/$PKG")
    if [[ ! -f "$NEW" ]] ; then
        cd "${i%/*}"
        fdpkg.sh "$PKG">/dev/null
        NVER="$(value $NAME/APPINFO/$NAME.LSM version)"
        NENT="$(value $NAME/APPINFO/$NAME.LSM entered-date)"
        NLIC="$(value $NAME/APPINFO/$NAME.LSM copying-policy)"
        fdpkg.sh "$NAME" >/dev/null
        cd "$NEWP"
        echo "New --> $NAME, $NVER, $NENT ($NLIC)"
    fi
done