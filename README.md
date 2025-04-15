![Build Status](https://github.com/asalamon74/solarwind/actions/workflows/shellcheck.yml/badge.svg)

# solarwind
Total solar eclipse corona/solarwind enhancer [imagemagick](http://www.imagemagick.org) script. The steps of the script are described [here](solarwind_tutorial.md).

```
Usage: solarwind.sh [options] inputfile outputfile

Options:
  -h, --help                  display this help
      --middle=x,y            manually specified middle position
      --opendisk=radius       radius of the opendisk
      --closedisk=radius      radius of the closedisk
      --radialblur=angle      angle of the radial bluar
      --modulate=brightness   brightness value for modulate (default: 200)
      --middleoutputfile=file if specified the middle positioned image will also be saved
      --nomiddle              do not position the image
```

## Sample

|Input|Output|
|-----|------|
|[![input](../gh-pages/sample_input_300.jpg)](../gh-pages/sample_input_1000.jpg)|[![output](../gh-pages/sample_output_300.jpg)](../gh-pages/sample_output_1000.jpg)|

# solarmiddle

The package also contains the solarmiddle script which automatically positiones total solar eclipse corona images. The steps of the script are described [here](solarmiddle_tutorial.md).
It is also possible to specify the middle position manually using the `--middle` option.

```
Usage:
  solarmiddle.sh [options] inputfile outputfile
 or
  solarmiddle.sh [options] inputfile

If no output file is specified, only prints out the middle position

Options:
  -h, --help                display this help
      --middle=x,y          manually specified middle position
      --opendisk=radius     radius of the opendisk
      --closedisk=radius    radius of the closedisk
```
