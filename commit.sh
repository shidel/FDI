#!/bin/sh

git add *.bat *.md LICENSE
git add BINARIES\*.TXT
git add PACKAGES\*.TXT
git add V8POWER\*.TXT
git add WELCOME\*
git add *.sh
git add $(find -P SETTINGS -type f)
git add $(find -P FDISETUP -type f)
git add $(find -P LANGUAGE -type f -iname *.def)
git add $(find -P LANGUAGE -type f -iname SETLANG.BAT)

git commit -m "$*"
git push