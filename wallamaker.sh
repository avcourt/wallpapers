#!/bin/bash

RES=500 # max thumb resolution, if you are running out of memory and
        # mogrify or montage is failing, try lowering this value.

echo "Checking directory structure."
if [ -d hi_res ] && [ -d thumbs ]; then
    echo "It looks like you have run wallamaker.sh before."
    echo "Ignoring images already in hi_res/"
    echo "Note: NEW photos should be placed in the directory root, not hi_res/."
    rm -v contact-sheet.jpg
    echo "Updating thumbnails with new images..."
    echo "Generating new thumbnails with max dimension $RES pixels"
    mogrify -format jpg -path thumbs -thumbnail "$RES"x"$RES" *.{gif,jpeg,jpg,png} 2>/dev/null
    mv -v *.{gif,jpeg,jpg,png} hi_res 2>/dev/null
else
    echo "Creating hi_res/ and /thumb/ directories"
    mkdir hi_res thumbs
    mv *.{gif,jpeg,jpg,png} hi_res 2>/dev/null
    echo "Generating thumbnails with max dimension $RES pixels"
    mogrify -format jpg -path thumbs -thumbnail "$RES"x"$RES" hi_res/*
fi

echo "Generating contact sheet"
montage thumbs/* contact-sheet.jpg

echo "Generating README"
printf "![contact sheet](contact-sheet.jpg)\n" >> README.md
for image in hi_res/*
do
    printf "\n### [$image]($image)\n" >> README.md
    printf "\n![$image]($image)\n" >> README.md
    printf "\n***\n" >> README.md
done
