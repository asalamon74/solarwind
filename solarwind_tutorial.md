# solarwind tutorial

The usage of the script can be found [here](README.md).

This [imagemagick](http://www.imagemagick.org) script emphasizes the corona details using the followings:

* A radial gradient filter changes the brightness of the corona based on the difference from the sun's limb.
* The difference of the original image and the radial blur of the image is used to show more corona details (similarly to the Pellett-method)
* The protuberance is taken from the original image.

## Steps of processing

The script calls [solarmiddle.sh](solarmiddle.sh) and positions the Sun to the middle of the image. The steps of the positioning script are described [here](solarmiddle_tutorial.md).

|Step|Description|Imagemagick|Image|
|----|-----------|-----------|-----|
|Input|Already positioned input image||[![input](../gh-pages/solarwind_step00_300.jpg)](../gh-pages/solarwind_step00_1000.jpg)|
|Image 1|Generated radial-gradient|-size ${fsizex}x${fsizey} radial-gradient:black-white -gamma 0.3|[![input](../gh-pages/solarwind_step01_300.jpg)](../gh-pages/solarwind_step01_1000.jpg)|
|Image 2|Grayscale of input image|-clone 0 -colorspace gray|[![input](../gh-pages/solarwind_step02_300.jpg)](../gh-pages/solarwind_step02_1000.jpg)|
|Image 3|Multiply and normalize previous two images| -clone 0 -clone 1 -compose Multiply -composite -normalize|[![input](../gh-pages/solarwind_step03_300.jpg)](../gh-pages/solarwind_step03_1000.jpg)|
|Image 4|Difference of original (Input) and grayscale (Image 2) images| -clone 0 -clone 2 -compose Minus -composite|[![input](../gh-pages/solarwind_step04_300.jpg)](../gh-pages/solarwind_step04_1000.jpg)|
|Image 5|Creating mask from the previous (Image 5) image|+clone -auto-level -modulate 200 +dither -colors 2 -colorspace gray -contrast-stretch 0|[![input](../gh-pages/solarwind_step05_300.jpg)](../gh-pages/solarwind_step05_1000.jpg)|
|Image 6|Blur the mask|+clone -blur 20x20|[![input](../gh-pages/solarwind_step06_300.jpg)](../gh-pages/solarwind_step06_1000.jpg)|
|Image 7|Negate the mask (image 5)| -clone 5 -negate|[![input](../gh-pages/solarwind_step07_300.jpg)](../gh-pages/solarwind_step07_1000.jpg)|
|Image 8|Blur the negated mask (image 7)|+clone -blur 20x20|[![input](../gh-pages/solarwind_step08_300.jpg)](../gh-pages/solarwind_step08_1000.jpg)|
|Image 9|Apply the blurred mask to cut out the protuberance|+clone -clone 3 -compose Multiply -composite|[![input](../gh-pages/solarwind_step09_300.jpg)](../gh-pages/solarwind_step09_1000.jpg)|
|Image 10|Apply the negated mask to show the protuberance|-clone 6 -clone 0 -compose Multiply -composite|[![input](../gh-pages/solarwind_step10_300.jpg)](../gh-pages/solarwind_step10_1000.jpg)|
|Image 11|Grayscale version of the protuberance difference|-clone 4 -colorspace gray|[![input](../gh-pages/solarwind_step11_300.jpg)](../gh-pages/solarwind_step11_1000.jpg)|
|Image 12|Fade out the protuberance| -clone 2 +clone -compose Mathematics -set option:compose:args 0,-2.5,1,0 -composite|[![input](../gh-pages/solarwind_step12_300.jpg)](../gh-pages/solarwind_step12_1000.jpg)|
|Image 13|Radial blur of the previous image|+clone -radial-blur 10|[![input](../gh-pages/solarwind_step13_300.jpg)](../gh-pages/solarwind_step13_1000.jpg)|
|Image 14|Difference of the previous two images|-clone -2 +clone -type TrueColor -compose Mathematics -set option:compose:args 0,-1,1,0.5 -composite|[![input](../gh-pages/solarwind_step14_300.jpg)](../gh-pages/solarwind_step14_1000.jpg)|
|Image 15|Increasing contrast|+clone -level 40%,60% -clamp +level 20%,80%|[![input](../gh-pages/solarwind_step15_300.jpg)](../gh-pages/solarwind_step15_1000.jpg)|
|Image 16|Using the previous image to emphasize corona details|-clone 9 +clone -compose Multiply -composite -auto-level|[![input](../gh-pages/solarwind_step16_300.jpg)](../gh-pages/solarwind_step16_1000.jpg)|
|Image 17|Add back the protuberance|+clone -clone 10 -compose Plus -composite|[![input](../gh-pages/solarwind_step17_300.jpg)](../gh-pages/solarwind_step17_1000.jpg)|
