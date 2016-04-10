#!/bin/bash

inputfile=$1

convert ${inputfile} -colorspace gray solarmiddle_step01.png
convert solarmiddle_step01.png -auto-level solarmiddle_step02.png
convert solarmiddle_step02.png -modulate 5000 solarmiddle_step03.png
convert solarmiddle_step03.png +dither -colors 2 -contrast-stretch 0 solarmiddle_step04.png
convert solarmiddle_step04.png -morphology Open Disk:2 solarmiddle_step05.png
convert solarmiddle_step05.png -morphology Close Disk:30 solarmiddle_step06.png
convert solarmiddle_step06.png -bordercolor black -border 10x10 solarmiddle_step07.png
convert solarmiddle_step07.png -fill white -floodfill +0+0 black solarmiddle_step08.png
trimbox=$(convert solarmiddle_step08.png -trim -format "%X %Y %@" info:);
bsize=$(echo $trimbox | cut -f 3 -d ' ' | cut -f 1 -d '+')
bsizex=$(echo $bsize | cut -f 1 -d 'x')
bsizey=$(echo $bsize | cut -f 2 -d 'x')
bx=$(echo $trimbox | cut -f 1 -d ' ' | cut -f 2 -d '+')
bx2=$(echo $trimbox | cut -f 3 -d ' ' | cut -f 2 -d '+')
by=$(echo $trimbox | cut -f 2 -d ' ' | cut -f 2 -d '+')
by2=$(echo $trimbox | cut -f 3 -d ' ' | cut -f 3 -d '+')
bx=$(($bx+$bx2-10))
by=$(($by+$by2-10))
midx=$((${bx}+${bsizex}/2))
midy=$((${by}+${bsizey}/2))
iwidth=$(identify -ping -format "%w" ${inputfile})
iheight=$(identify -ping -format "%h" ${inputfile})
fsizex=$((${midx} > ${iwidth}-${midx} ? 2*(${iwidth}-${midx}) : 2*${midx}))
fsizey=$((${midy} > ${iheight}-${midy} ? 2*(${iheight}-${midy}) : 2*${midy}))
TOPX=$(($midx-$fsizex/2))
TOPY=$(($midy-$fsizey/2))
convert solarmiddle_step08.png -fill none -stroke red -strokewidth 3 -draw "rectangle $((${bx}+10)),$((${by}+10)), $(($bx+$bsizex+10)),$(($by+$bsizey+10)) line $(($bx+$bsizex+10)),$((${by}+10)), $((${bx}+10)),$(($by+$bsizey+10)) line $((${bx}+10)),$((${by}+10)), $(($bx+$bsizex+10)),$(($by+$bsizey+10))" solarmiddle_step09.png
convert ${inputfile} -fill none -stroke blue -strokewidth 3 -draw "rectangle ${TOPX},${TOPY} $((${fsizex}+${TOPX})),$((${fsizey}+${TOPY}))" solarmiddle_step10.png


