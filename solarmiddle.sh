#!/bin/bash

SWTMPROOTDIR="."
SWTMPDIR="${SWTMPROOTDIR}/SOLARWIND.$$"

cleanup() {
  rv=$?
  rm -rf $SWTMPDIR
  exit $rv
}

trap cleanup INT TERM EXIT

usage() {
    echo "Usage:"
    echo "  $(basename "$0") [options] inputfile outputfile"
    echo ""
    echo "Options:"
    echo "  -h, --help                display this help"
    echo "      --opendisk=radius     radius of the opendisk"
    echo "      --closedisk=radius    radius of the closedisk"
}

error() {
    echo "$1"
    usage
    exit 1
}

# defaults
opendisk=2
closedisk=30

for i in "$@"
do
case $i in
    -h|--help)
    usage
    exit
    ;;
    --opendisk=*)
    opendisk="${i#*=}"
    shift # past argument=value
    ;;
    --closedisk=*)
    closedisk="${i#*=}"
    shift # past argument=value
    ;;
    # --default)
    # DEFAULT=YES
    # shift # past argument with no value
    # ;;
    -*)
    echo "Unknown option $1"
    usage
    exit 1
    ;;
esac
done

if [[ -n $1 ]]; then
inputfile=$1
fi

if [[ -n $2 ]]; then
outputfile=$2
fi

mkdir "$SWTMPDIR" || error "CANNOT CREATE TEMPORARY FILE DIRECTORY"


[ "$inputfile" = "" ] && error "NO INPUT FILE SPECIFIED"
[ "$outputfile" = "" ] && error "NO OUTPUT FILE SPECIFIED"

inputbase=${inputfile##*/}
inputbase=${inputbase%.*}

convert ${inputfile} -colorspace gray -auto-level -modulate 5000 +dither -colors 2 -contrast-stretch 0 -morphology Open Disk:${opendisk} -morphology Close Disk:${closedisk} -bordercolor black -border 10x10 -fill white -floodfill +0+0 black ${SWTMPDIR}/${inputbase}_mask.png
trimbox=$(convert ${SWTMPDIR}/${inputbase}_mask.png -trim -format "%X %Y %@" info:);
bsize=$(echo "$trimbox" | cut -f 3 -d ' ' | cut -f 1 -d '+')
bsizex=$(echo "$bsize" | cut -f 1 -d 'x')
bsizey=$(echo "$bsize" | cut -f 2 -d 'x')
bx=$(echo "$trimbox" | cut -f 1 -d ' ' | cut -f 2 -d '+')
bx2=$(echo "$trimbox" | cut -f 3 -d ' ' | cut -f 2 -d '+')
by=$(echo "$trimbox" | cut -f 2 -d ' ' | cut -f 2 -d '+')
by2=$(echo "$trimbox" | cut -f 3 -d ' ' | cut -f 3 -d '+')
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
convert ${inputfile} -crop ${fsizex}x${fsizey}+${TOPX}+${TOPY} +repage ${outputfile}
