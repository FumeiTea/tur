#!/bin/bash

F=$PREFIX/tmp/android-sdk.tar.xz
DIR=$PREFIX/opt/android-sdk
MD5="ee664b3a73737a7420856c4c8641665a"

[[ $1 == -rm ]] && rm $F

[ -f $F ] && mapfile -t -d ' ' md5 < <(md5sum $PREFIX/tmp/android-sdk.tar.xz)
[[ $MD5 != ${md5[0]} ]] \
  && echo Start Download && curl -fL -C - \
    --progress-bar \
    --retry 3 \
    --retry-delay 5 \
    --retry-max-time 30 \
    -o $F \
    https://github.com/AndroidIDEOfficial/androidide-tools/releases/download/sdk/android-sdk.tar.xz \
  && echo Download Success

[ ! -d $DIR ] && [ ! -e $DIR ] && mkdir $DIR
[ ! -d $DIR ] && echo ! not is dir && exit -1

echo Start decompression
i=0
: "${COLUMNS:=$(stty size 2>/dev/null | awk '{print $2}')}"
COLUMNS=$((COLUMNS-10))
while read -r l ;do
  ((i++))
  printf "\033[2K\r%-6s %.${COLUMNS}s" $(( i / 66 ))%  $l
done < <(tar -xvf $F -C $DIR)
echo -e "\033[2K\rDecompression completed"

[[ -d $DIR/android-sdk/ ]] && mv $DIR/android-sdk/* $DIR &>/dev/null

# vim: set ft=sh ts=2 sw=2 sts=2 et :
