#!/bin/sh

git add *.bat *.md LICENSE
git add BINARIES\*.TXT BINARIES\*.BAT
git add PACKAGES\*.TXT
git add V8POWER\*.TXT
git add WELCOME\*
git add TOOLS\*.sh TOOLS\*.bat
git add $(find -P SETTINGS -type f)
git add $(find -P FDISETUP -type f)
git add $(find -P KEYBOARD -type f)
git add $(find -P LANGUAGE -type f -iname *.DEF)
git add $(find -P LANGUAGE -type f -iname *.BAT)
git add $(find -P LANGUAGE -type f -iname *.LST)

git commit -m "$*"
git push