# solarmiddle tutorial

Automatic symmetric positioning of total solar eclipse corona images

## Steps of processing

|Step 0|Step 1|Step 2|
|------|------|------|
|[![input](../gh-pages/sample_input_300.jpg)](../gh-pages/sample_input_1000.jpg)|[![output](../gh-pages/solarmiddle_step01_300.jpg)](../gh-pages/solarmiddle_step01_1000.jpg)|[![output](../gh-pages/solarmiddle_step02_300.jpg)](../gh-pages/solarmiddle_step02_1000.jpg)|
|Original image|Grayscale|Very bright|
||-colorspace gray|-auto-level<br />-modulate 5000<br />|
|**Step 3**|**Step 4**|**Step 5**|
|[![output](../gh-pages/solarmiddle_step03_300.jpg)](../gh-pages/solarmiddle_step03_1000.jpg)|[![output](../gh-pages/solarmiddle_step04_300.jpg)](../gh-pages/solarmiddle_step04_1000.jpg)|[![output](../gh-pages/solarmiddle_step05_300.jpg)](../gh-pages/solarmiddle_step05_1000.jpg)|
|Two-color|Remove white dots|Remove black dots|
|+dither<br/>-colors 2<br />-contrast-stretch 0|-morphology Open Disk:2|-morphology Close Disk:30|


