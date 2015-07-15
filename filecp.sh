#!/bin/bash
IMG=/root/pendrive.img
MNTPOINT=/mnt/pendrive/
UPLOADDIR=/opt/webchan/upload/

sleep 3
find $MNTPOINT -type f -exec du -b {} \; > tree1
umount $MNTPOINT
mount -oro,loop,offset=$((2048 * 512)) -t vfat $IMG $MNTPOINT
find $MNTPOINT -type f -exec du -b {} \; > tree2

diff -y --suppress-common-lines -W 20000 tree1 tree2 | rev | cut -f 1 | rev | while read FILE
do
  if echo $FILE | grep -q "<$"; then
    echo -n
  else
    cp -v "${FILE[@]}" ${UPLOADDIR}
  fi
done