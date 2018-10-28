#!/bin/bash
for files in VIDEO/*.mkv; do ffmpeg -i "$files" -c:v copy -c:a aac  "${files%.*} [Streamable].mp4"; done
