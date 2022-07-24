#!/bin/bash

C=15

for f in $(ls -1 ./tiles/white) ; do magick convert ./tiles/white/$f -fill "rgb(255,127,0)" -level "0%,70%,1.2"  ./tiles/white/$f ; done
for f in $(ls -1 ./tiles/black) ; do magick convert ./tiles/black/$f -fill "rgb(0,0,0)"     -level "0%,100%,0.4" ./tiles/black/$f ; done
