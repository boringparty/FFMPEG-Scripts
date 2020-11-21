# Simple FFMPEG Scripts

These are some simple FFMPEG scripts I use for common conversions.

I keep these scripts in a folder called `_CONVERT` -- and I have subfolders tited `AUDIO`, `BOOKS`, `VIDEO`. Adjust the scripts accordingly to suit your structure.

## books.sh

Transfer folders of audiobooks (one folder per book) to `BOOKS/` and the simple script will combine the mp3s and name the output to the folder name. e.g. `BOOKS/Gillian Flynn - Sharp Objects/` returns `BOOKS/Gillian Flynn - Sharp Objects.mp3`

```
#!/bin/bash
for dirname in BOOKS/*; do cat "${dirname}"/* > "${dirname}".mp3;done
```

## flac24-16.sh

This transcodes 24/?KHz FLAC files to 16bit 48KHz FLAC.

```
#!/bin/bash
for files in AUDIO/*.flac; do ffmpeg -i "$files" -c:a flac -sample_fmt s16 -ar 48000 "${files%.*} (16 48).flac"; done;
```

## flac2aac.sh

Using `AUDIO/` for the source directory. I have no idea what I made this for, but it converts FLAC to a decent quality AAC. I suspect this was for audiobooks or something.

```
#!/bin/bash
for files in AUDIO/*.flac; do ffmpeg -i "$files" -c:a libfdk_aac -vbr 5 "${files%.*}.m4a"; done;
```

## flac2alac.sh

Quick blanket conversion of FLAC files to ALAC for use with iTunes. I had to use `-map 0:0` to get around an issue with embedded album art.

```
#!/bin/bash
for files in AUDIO/*.flac; do ffmpeg -i "$files" -map 0:0 -acodec alac "${files%.*}".m4a; done;
```

## mkv2mp4.sh

This is a transcode I typically use for DTS to Stereo to prep quick (usually fun) projects for Adobe Premiere.

```
#!/bin/bash
for files in VIDEO/*.mkv; do ffmpeg -i "$files" -c:v copy \
    -ac 2 -af "pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR" \
    "${files%.*} [Stereo].mp4"; done
```

## mkvcut.sh

This is a quick way to trim a video and transcode it for use with Streamable. 

`sh mkvcut.sh S01E01.mkv 09:00 04:00 mp4`

This will take `S01E01.mkv` and, starting at 9m, will output the following 4m to `S01E01-output.mp4`

Since I usually use this from my desktop, I am not specifying a source folder.

```
#!/bin/bash
file="$1"
ffmpeg -i $1 -ss $2 -t $3 -c:v libx264 -crf 22 -c:a aac -movflags faststart ""${file%.*}"-output.$4"
```

## streamable.sh

This is a straight prep file for Streamable that I use if I don't need to trim down the source. Nothing fancy. 

```
#!/bin/bash
for files in VIDEO/*.mkv; do ffmpeg -i "$files" -c:v copy -c:a aac  "${files%.*} [Streamable].mp4"; done
```
##ZSH Aliases

###Quick Cuts

```
function ffcut() {
    ffmpeg -ss $2 -i "$1" -to $3 -c copy "final-$1"
}
```

###Remove Chapters

```
function ffremchap() {
for files in *.m4b; do ffmpeg -i "$files" -map_chapters -1 -c copy "${files%.*}".m4a; mv "$files" _"$files";done;
}
```

###Quick Convert to FLAC and ALAC

This is typically used when I have some 24/96 FLACs that I need to resample to 16/44 to add to my iPod (modded, running Rockbox) and also my iPhone

```
function convertalbum(){
mkdir FLAC;
mkdir ALAC;
for i in *.flac;
 do echo $i;
  ffmpeg -i "$i" \
    -y -v 0 -vcodec copy -acodec alac -af aresample=osf=s16:osr=44100 "ALAC/${i%}.m4a" \
    -af aresample=osf=s16:osr=44100 "FLAC/${i%}.flac";
  done
}
```

###Make GIFs (soft G)

```
function  makegif(){
        ffmpeg -i $1 -vf "fps=10,scale=$2:-1:flags=lanczos" -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize $1.gif
}
```
