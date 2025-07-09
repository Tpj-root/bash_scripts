#!/bin/bash

# Input image
INPUT="/home/cnc/Desktop/MY_GIT/bash_scripts/Source.JPG"
OUTPUT="glitched-output_v1.jpg"

# Temp folder
mkdir -p temp_strips_1
rm -f temp_strips/*.jpg

# Set number of horizontal strips
STRIPS=20

# Get image dimensions
HEIGHT=$(identify -format "%h" "$INPUT")
WIDTH=$(identify -format "%w" "$INPUT")

# Calculate strip height
STRIP_HEIGHT=$((HEIGHT / STRIPS))

# Create strips with random x-offset
for ((i = 0; i < STRIPS; i++)); do
    Y=$((i * STRIP_HEIGHT))
    OFFSET=$((RANDOM % 50))  # random horizontal offset

    # crop strip
    convert "$INPUT" -crop "${WIDTH}x${STRIP_HEIGHT}+0+${Y}" +repage "temp_strips/strip_$i.jpg"

    # shift randomly
    convert "temp_strips/strip_$i.jpg" -background black -gravity West -extent "$((WIDTH + OFFSET))x${STRIP_HEIGHT}" "temp_strips/strip_$i.jpg"
done

# Combine strips
convert temp_strips/strip_*.jpg -append "$OUTPUT"

echo "✅ Done: $OUTPUT created."
