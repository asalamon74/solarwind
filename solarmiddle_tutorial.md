# solarmiddle tutorial

This [imagemagick](http://www.imagemagick.org) script automatically positiones total solar eclipse
corona images. This script is used by [solarwind](README.md) script.

## Steps of processing

|Step 0|Step 1|Step 2|
|------|------|------|
|[![input](../gh-pages/sample_input_300.jpg)](../gh-pages/sample_input_1000.jpg)|[![output](../gh-pages/solarmiddle_step01_300.jpg)](../gh-pages/solarmiddle_step01_1000.jpg)|[![output](../gh-pages/solarmiddle_step02_300.jpg)](../gh-pages/solarmiddle_step02_1000.jpg)|
|Original image|Grayscale|Auto-level|
||-colorspace gray|-auto-level<br /><br />|
|**Step 3**|**Step 4**|**Step 5**|
|[![output](../gh-pages/solarmiddle_step03_300.jpg)](../gh-pages/solarmiddle_step03_1000.jpg)|[![output](../gh-pages/solarmiddle_step04_300.jpg)](../gh-pages/solarmiddle_step04_1000.jpg)|[![output](../gh-pages/solarmiddle_step05_300.jpg)](../gh-pages/solarmiddle_step05_1000.jpg)|
|Very bright|Two-color|Remove white dots|
|-modulate 5000|+dither<br/>-colors 2<br />-contrast-stretch 0|-morphology Open Disk:2|
|**Step 6**|**Step 7**|**Step 8**|
|[![output](../gh-pages/solarmiddle_step06_300.jpg)](../gh-pages/solarmiddle_step06_1000.jpg)|[![output](../gh-pages/solarmiddle_step07_300.jpg)](../gh-pages/solarmiddle_step07_1000.jpg)|[![output](../gh-pages/solarmiddle_step08_300.jpg)](../gh-pages/solarmiddle_step08_1000.jpg)|
|Remove black dots|Add black border|Floodfill|
|-morphology Close Disk:30|-bordercolor black<br />-border 10x10|-fill white<br /> -floodfill +0+0<br /> black|
|**Step 9**|**Step 10**|
|[![output](../gh-pages/solarmiddle_step09_300.jpg)](../gh-pages/solarmiddle_step09_1000.jpg)|[![output](../gh-pages/solarmiddle_step10_300.jpg)](../gh-pages/solarmiddle_step10_1000.jpg)|
|Find black circle|Crop|
|-trim<br />-format "%X %Y %@"<br />info:|-crop|

