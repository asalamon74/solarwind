[![Build Status](https://travis-ci.org/asalamon74/solarwind.svg?branch=master)](https://travis-ci.org/asalamon74/solarwind)

# solarwind
Total solar eclipse corona/solarwind enhancer [imagemagick](http://www.imagemagick.org) script. The steps of the script are described [here](solarwind_tutorial.md).

```
Usage: solarwind.sh [options] inputfile outputfile

Options:
  -h, --help                  display this help
      --opendisk=radius       radius of the opendisk
      --closedisk=radius      radius of the closedisk
      --radialblur=angle      angle of the radial bluar
      --middleoutputfile=file if specified the middle positioned image will also be saved
```

## Sample

|Input|Output|
|-----|------|
|[![input](../gh-pages/sample_input_300.jpg)](../gh-pages/sample_input_1000.jpg)|[![output](../gh-pages/sample_output_300.jpg)](../gh-pages/sample_output_1000.jpg)|

# solarmiddle

The package also contains the solarmiddle script which automatically positiones total solar eclipse corona images. The steps of the script are described [here](solarmiddle_tutorial.md).

```
Usage: solarmiddle.sh [options] inputfile outputfile

Options:
  -h, --help                display this help
      --opendisk=radius     radius of the opendisk
      --closedisk=radius    radius of the closedisk
```
