#!/bin/bash
for files in AUDIO/*.flac; do ffmpeg -i "$files" -map 0:0 -acodec alac "${files%.*}".m4a; done;
