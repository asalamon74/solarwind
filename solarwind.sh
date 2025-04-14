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
    echo "  -h, --help                  display this help"
    echo "      --middle=x,y            manually specified middle position"
    echo "      --opendisk=radius       radius of the opendisk"
    echo "      --closedisk=radius      radius of the closedisk"
    echo "      --radialblur=angle      angle of the radial blur"
    echo "      --middleoutputfile=file if specified the middle positioned image will also be saved"
}

error() {
    echo "$1"
    usage
    exit 1
}

error_nousage() {
    echo "$1"
    exit 1
}

# defaults
opendisk=2
closedisk=30
radialblur=10

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
    --middle=*)
    middlestr="${i#*=}"
    shift # past argument=value
    ;;
    --radialblur=*)
    radialblur="${i#*=}"
    shift # past argument=value
    ;;
    --middleoutputfile=*)
    middleoutputfile="${i#*=}"
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

MYDIR="$(dirname "$(realpath "$0")")"

"${MYDIR}/solarmiddle.sh" --opendisk="${opendisk}" --closedisk="${closedisk}" ${middlestr:+"--middle=$middlestr"} "$1" "${SWTMPDIR}/${inputbase}_cuta.png" || error_nousage "CANNOT POSITION IMAGE"

fsizex=$(identify -ping -format "%w" "${SWTMPDIR}/${inputbase}_cuta.png")
fsizey=$(identify -ping -format "%h" "${SWTMPDIR}/${inputbase}_cuta.png")

convert "${SWTMPDIR}/${inputbase}_cuta.png" \
    \( -size "${fsizex}"x"${fsizey}" radial-gradient:black-white -gamma 0.3 \) \
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
    \( +clone -radial-blur "${radialblur}" \) \
    \( -clone -2 +clone -type TrueColor -compose Mathematics -set option:compose:args 0,-1,1,0.5 -composite \) \
    \( +clone -level 40%,60% -clamp +level 20%,80% \) \
    \( -clone 9 +clone -compose Multiply -composite -auto-level \) \
    \( +clone -clone 10 -compose Plus -composite \) \
    -delete 0--2 \
"${outputfile}"

if [ -n "$middleoutputfile" ]; then
    mv "${SWTMPDIR}/${inputbase}_cuta.png" "$middleoutputfile"
fi
