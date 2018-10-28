#!/bin/bash
for files in AUDIO/*.flac; do ffmpeg -i "$files" -c:a flac -sample_fmt s16 -ar 48000 "${files%.*} (16 48).flac"; done;
