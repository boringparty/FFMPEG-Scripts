#!/bin/bash
for files in VIDEO/*.mkv; do ffmpeg -i "$files" -c:v copy \
    -ac 2 -af "pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR" \
    "${files%.*} [Stereo].mp4"; done
