#!/bin/bash
file="$1"
ffmpeg -i $1 -ss $2 -t $3 -c:v libx264 -crf 22 -c:a aac -movflags faststart "${file%.*}"-output.$4
