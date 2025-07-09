#!/bin/bash

# 📷 Input and output image filenames
INPUT="/home/cnc/Desktop/MY_GIT/bash_scripts/Source.JPG"
OUTPUT="glitched-output_v2.jpg"

# 📁 Create temp folder for strips
#mkdir -p strips
mkdir -p temp_strips_2


# 🧹 Remove any existing strip files
rm -f strips/*.png

# 🔧 Configuration
STRIPS=20       # Number of horizontal slices (strips)
SPOTS=15        # Number of black rectangles per strip
SPOT_W=40       # Width of each black rectangle
SPOT_H=10       # Height of each black rectangle

# 📐 Get original image size
HEIGHT=$(identify -format "%h" "$INPUT")   # Full image height
WIDTH=$(identify -format "%w" "$INPUT")    # Full image width

# 🔲 Height of each strip
STRIP_H=$((HEIGHT / STRIPS))

# 🔁 Loop to create strips and add black boxes
for ((i=0; i<STRIPS; i++)); do
  # 🟫 Y offset for cropping strip
  Y=$((i * STRIP_H))

  # 🏷️ Format output filename with zero-padded index (e.g., strip_00.png)
  printf -v FNAME "strips/strip_%02d.png" "$i"

  # ✂️ Crop the strip from the image
  convert "$INPUT" -crop "${WIDTH}x${STRIP_H}+0+${Y}" +repage "$FNAME"

  # 🔳 Add black rectangles (glitch effect)
  for ((j=0; j<SPOTS; j++)); do
    # 🎯 Random X and Y positions for each black box
    X_OFF=$((RANDOM % (WIDTH - SPOT_W)))
    Y_OFF=$((RANDOM % (STRIP_H - SPOT_H)))

    # 🖌️ Draw black rectangle on the strip
    convert "$FNAME" -fill black -draw "rectangle $X_OFF,$Y_OFF $((X_OFF + SPOT_W)),$((Y_OFF + SPOT_H))" "$FNAME"
  done
done

# 🧵 Combine all strips vertically in correct order
convert strips/strip_*.png -append "$OUTPUT"

# ✅ Final status
echo "✅ Output saved as $OUTPUT"
