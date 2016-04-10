# solarmiddle tutorial

Automatic symmetric positioning of total solar eclipse corona images

## Steps of processing

|Step 0|Step 1|Step 2|
|-----|------|
|[![input](../gh-pages/sample_input_300.jpg)](../gh-pages/sample_input_1000.jpg)|[![output](../gh-pages/solarmiddle_step01_300.jpg)](../gh-pages/solarmiddle_step01_1000.jpg)|[![output](../gh-pages/solarmiddle_step02_300.jpg)](../gh-pages/solarmiddle_step02_1000.jpg)|
|Original image|Grayscale|Two-color|
||-colorspace gray|-auto-level -modulate 5000 +dither -colors 2 -contrast-stretch 0|


