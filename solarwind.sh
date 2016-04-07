#!/bin/bash

cleanup() {
  rv=$?
  rm -rf $TMPDIR
  exit $rv
}

trap cleanup INT TERM EXIT

TMPROOTDIR="."
TMPDIR="${TMPROOTDIR}/SOLARWIND.$$"
mkdir "$TMPDIR" || { echo "CANNOT CREATE TEMPORARY FILE DIRECTORY"; exit 1; }

inputfile=$1

[ "$inputfile" = "" ] && { echo "NO INPUT FILE SPECIFIED"; exit 1; }

inputbase=${inputfile##*/}
inputbase=${inputbase%.*}

findmiddle() {
    convert ${inputfile} -colorspace gray -auto-level -modulate 5000 +dither -colors 2 -contrast-stretch 0 -morphology Open Disk:2 -morphology Close Disk:30 -bordercolor black -border 10x10 -fill white -floodfill +0+0 black ${TMPDIR}/${inputbase}_mask.png
    trimbox=$(convert ${TMPDIR}/${inputbase}_mask.png -trim -format "%X %Y %@" info:);
    bsize=$(echo $trimbox | cut -f 3 -d ' ' | cut -f 1 -d '+')
    bsizex=$(echo $bsize | cut -f 1 -d 'x')
    bsizey=$(echo $bsize | cut -f 2 -d 'x')
    bx=$(echo $trimbox | cut -f 1 -d ' ' | cut -f 2 -d '+')
    bx2=$(echo $trimbox | cut -f 3 -d ' ' | cut -f 2 -d '+')
    by=$(echo $trimbox | cut -f 2 -d ' ' | cut -f 2 -d '+')
    by2=$(echo $trimbox | cut -f 3 -d ' ' | cut -f 3 -d '+')
    bx=$(($bx+$bx2-10))
    by=$(($by+$by2-10))
#    convert $1.png -fill none -stroke red -strokewidth 1 -draw "rectangle ${bx},${by} $(($bx+$bsizex)),$(($by+$bsizey))" $1_rect.png
    midx=$((${bx}+${bsizex}/2))
    midy=$((${by}+${bsizey}/2))
    iwidth=$(identify -ping -format "%w" ${inputfile})
    iheight=$(identify -ping -format "%h" ${inputfile})
    fsizex=$((${midx} > ${iwidth}-${midx} ? 2*(${iwidth}-${midx}) : 2*${midx}))
    fsizey=$((${midy} > ${iheight}-${midy} ? 2*(${iheight}-${midy}) : 2*${midy}))
    TOPX=$(($midx-$fsizex/2))
    TOPY=$(($midy-$fsizey/2))
    convert ${inputfile} -crop ${fsizex}x${fsizey}+${TOPX}+${TOPY} +repage ${TMPDIR}/${inputbase}_cuta.png
}

findmiddle $1

convert ${TMPDIR}/${inputbase}_cuta.png \
    \( -size ${fsizex}x${fsizey} radial-gradient:black-white -gamma 0.3 \) \
    \( -clone 0 -colorspace gray \) \
    \( -clone 0 -clone 1 -compose Multiply -composite -normalize \) \
    \( -clone 0 -clone 2 -compose Minus -composite \) \
    \( +clone -auto-level -modulate 200 +dither -colors 2 -colorspace gray -contrast-stretch 0 \) \
    \( +clone -blur 20x20 \) \
    \( -clone 5 -negate \) \
    \( +clone -blur 20x20 \) \
    \( +clone -clone 3 -compose Multiply -composite \) \
    \( -clone 6 -clone 0 -compose Multiply -composite \) \
    \( -clone 4 -colorspace gray \) \
    \( -clone 2 +clone -compose Mathematics -set option:compose:args 0,-2.5,1,0 -composite \) \
    \( +clone -radial-blur 10 \) \
    \( -clone -2 +clone -type TrueColor -compose Mathematics -set option:compose:args 0,-1,1,0.5 -composite \) \
    \( +clone -level 40%,60% -clamp +level 20%,80% \) \
    \( -clone 9 +clone -compose Multiply -composite -auto-level \) \
    \( +clone -clone 10 -compose Plus -composite \) \
    -delete 0--2 \
${inputbase}_swa.png



