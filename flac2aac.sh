#!/bin/bash
for files in AUDIO/*.flac; do ffmpeg -i "$files" -c:a libfdk_aac -vbr 5 "${files%.*}.m4a"; done;
