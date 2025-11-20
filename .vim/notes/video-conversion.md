# Video editing guide

---

Gif to mp4 conversion

- Using ffmpeg
- Using handbrake
  - Automated

Basic editing

- Using lossless cut

Upscaling

- Using ffmpeg with the 'neighbor' algorithm
- Example results/comparisonS

```pre
  ┌────────┬────────┬────────┬────────┏━━━━━━━━━┓────────┬────────┬──────────┐
  │  1 ╱   │  1 ╱   │  1 ╱   │  2 ╱   ┃  1 ╱    ┃  2 ╱   │  4 ╱   │ fraction │
  │   ╱ 4  │   ╱ 3  │   ╱ 2  │   ╱ 3  ┃   ╱ 1   ┃   ╱ 1  │   ╱ 1  │ of 1080p │
  ├────────┼────────┼────────┼────────┣━━━━━━━━━┫────────┼────────┼──────────┤
  │  'SD'  │  '⅓p'  │  '½p'  │  720p  ┃  1080p  ┃   4K   │   8K   │  alias   │
  ├────────┼────────┼────────┼────────┣━━━━━━━━━┫────────┼────────┼──────────┤
  │ 480    │ 640    │ 960    │ 1280   ┃ 1920    ┃ 3840   │ 7680   │ width    │
  │    270 │    360 │    540 │    720 ┃    1080 ┃   2160 │   4320 │   height │
  └────────┴────────┴────────┴────────┗━━━━━━━━━┛────────┴────────┴──────────┘
```

```pre
  ╭─────────────────╮
  │  base: 960x540  │
  ┢━━━━━┓─────┬─────┼─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
  ┃ 1/1 ┃     │ 5/6 │     │ 3/4 │     │ 4/6 │     │ 1/2 │     │ 2/6 │     │ 1/4 │     │ 1/6 │     │
  ┣━━━━━┫─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
  ┃ 960 ┃ 864 │ 800 │ 768 │ 720 │ 672 │ 640 │ 576 │ 480 │ 384 │ 320 │ 288 │ 240 │ 192 │ 160 │  96 │
  ┃ 540 ┃ 486 │ 450 │ 432 │ 405!│ 378 │ 320 │ 324 │ 270 │ 216 │ 180 │ 162 │ 135!│ 108 │  90 │  54 │
  ┣━━━━━┫─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
  ┃  1  ┃ .9  │ .833│ .8  │ .75 │ .7  │ .666│ .6  │ .5  │ .4  │ .333│ .3  │ .25 │ .2  │ .166│ .1  │
  ┗━━━━━┛─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```

```pre
  400     800     1600    2400    3200
  225     450     900     1350    1800

  300  600  1200
  200  400   800
```

```pre
    to 8K:      ╭─╴x24╶──╭──╴x16╶─╭──╴x12╶──╭─╴x8╶───╭──╴x6╶────╭╴x4╶───────╭─╴x2╶──╮
       4K:      ├─╴x12╶──├──╴x8╶──├──╴x6╶───├─╴x4╶───├──╴x3╶────├╴x2╶──────╮│       │
     1080p:     ├─╴x6╶───├──╴x4╶──├──╴x3╶───├─╴x2╶───│─────────╮│          ││       │
 ┌──────────┬───∆────┬───∆────┬───∆────┬────∆───┬────∆───┏━━━━━∇∆━━━━━━┓───∇∆───┬───∇────┐
 │  alias   │  '⅙p'  │  'SD'  │  '⅓p'  │  '½p'  │  720p  ┃    1080p    ┃   4K   │   8K   │
 ├──────────┼────────┼────────┼────────┼────────┼────────┣━━━━━━━━━━━━━┫────────┼────────┤
 │ fraction │  1 ╱   │  1 ╱   │  1 ╱   │  1 ╱   │  2 ╱   ┃ ←fraction   ┃   2x   │   4x   │
 │ of 1080p │   ╱ 6  │   ╱ 4  │   ╱ 3  │   ╱ 2  │   ╱ 3  ┃   multiple→ ┃        │        │
 ├──────────┼────────┼────────┼────────┼────────┼────────┣╸           ╺┫────────┼────────┤
 │ width    │ 320    │ 480    │ 640    │ 960    │ 1280   ┃  1920 width ┃ 3840   │ 7680   │
 │   height │    180 │    270 │    360 │    540 │    720 ┃ height 1080 ┃   2160 │   4320 │
 └──────────┴────∇───┴────∇───┴───∆∇───┴───∆∇───┴───∆∇───┗━━━━━∆∇━━━━━━┛───∆∇───┴───∆∇───┘
                 │        ╰x2────┈││┈──────┤╰x2────┈││┈────────╯├x2────────┤╰x2─────╯│
                 ├x2──────────────╯├x2────┈│┈───────╯╰x3──────┈│̂│┈─────────╯         │
                 │                 ╰x3────┈│┈──────────────────┤╰x4──────────────────╯
                 ├x2───────────────────────╯                   │
                 ╰x6───────────────────────────────────────────╯
```

```bash
for png in *.png; do pngout $png; done
```

## MP4 -> GIF

## GIF -> MP4

### Upscaling (with nearest neighbor for pixel graphics)

#### 2x upscale, 960x540 -> 1080p

```bash
ffmpeg -i GIF-IN.gif -movflags faststart -pix_fmt yuv420p \
 -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -s 1920x1080 \
 -sws_flags neighbor MP4-OUT.mp4

ffmpeg -i IN.mp4 -s 1600x900 -sws_flags neighbor OUT.mp4
ffmpeg -i IN.mp4 -s 960x540 -sws_flags neighbor OUT.mp4
ffmpeg -i IN.mp4 -s 1920x1080 -sws_flags neighbor OUT.mp4
```

#### 2x upscale, 480x270 -> 960x540

```bash
ffmpeg -i input-480x270.gif -movflags faststart -pix_fmt yuv420p \
 -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -s 960x540 \
 -sws_flags neighbor output.upscaled2x.960x540.yuv420p.mp4
```

#### 4x upscale, 480x270 -> 1080p

```bash
ffmpeg -i input.480x270.gif -movflags faststart -pix_fmt yuv420p \
 -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -s 1920x1080 \
 -sws_flags neighbor output.upscaled4x.1080p.yuv420p.mp4

ffmpeg -i input.240x135.gif -movflags faststart -pix_fmt yuv420p \
 -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -s 960x540 \
 -sws_flags neighbor output.upscaled4x.960x540.yuv420p.mp4

ffmpeg -i input.240x135.gif -movflags faststart -pix_fmt yuv420p \
 -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -s 960x540 \
 -sws_flags neighbor output.upscaled4x.960x540.yuv420p.mp4
```

## Downscaling

#### 1/2

e.g. 4K -> 2K -> 1080p -> 940x560 -> 470x280
720p -> 640x360 -> 320x180

```bash
ffmpeg -i input.mp4 -vf 'scale=in_w/2:in_h/2' -c:a copy output.scaled.mp4
```

## Cropping

#### 2/3

e.g. 1080p -> 720p

> trunc(in_w/3)*2:trunc(in_h/3)*2

##### vertical offset from middle

```bash
ffplay -i input.mp4 -vf 'crop=trunc(in_w/3)*2:trunc(in_h/3)*2:0:-50+trunc(in_h/6)'
```

#### 1/2

e.g. 4K -> 2K -> 1080p -> 940x560 -> 470x280
720p -> 640x360 -> 320x180

> trunc(in_w/2):trunc(in_h/2)

#### 1/3

e.g. 2K -> 720p -> 240x120
1080p -> 640x360

> trunc(in_w/6)*2:trunc(in_h/6)*2

#### 1/4

e.g. 4K -> 1080p -> 480x270
2K -> 940x560

> trunc(in_w/4):trunc(in_h/4)

##### from middle

```bash
-vf crop='in_w/2:in_h/2:in_w/4:in_h/4'
```

##### Vertical offset from middle

```bash
ffplay -i input.mp4 -vf crop='in_w/2:in_h/2:in_w/4:-56+in_h/4'
ffmpeg -i input.mp4 -vf crop='in_w/2:in_h/2:in_w/4:-56+in_h/4' -c:a copy output.cropped.mp4
```

## Looping

```bash
ffmpeg -stream_loop 200 -i tele-loop.mp4 -c copy tele-looped.mp4
```

```bash
ffmpeg -f concat -i <(for i in {1..4}; do printf "file '%s'\n" input.mp4; done) -c copy output.mp4
```

## Concatenate

### Similar Sources

```bash
ffmpeg -f concat -i <(for i in {1..4}; do printf "file '%s'\n" input.mp4; done) -c copy output.mp4
```

### Differing sources (re-encoding)

## Create Image Slideshow

```bash
rm resized/*.jpg
 \ && mkdir -p resized
 \ && sips --resampleHeight 1080 -p 1080 1920 --padColor 000000 *.jpg --out resized/

ffmpeg -framerate 1 -pattern_type glob
 \ -i 'resized/*.jpg' -c:v libx264 -pix_fmt yuv420p slideshow-resized-1080p.mp4

```

## Set Video Thumbnail

#### Grab 1st frame of video

```bash
ffmpeg -i input.mp4 -frames:v 1 screenshot.png
```

#### Grab frame at time

```bash
ffmpeg -ss 00:00:15 -i input.mp4 -frames:v 1 ss-0015.png
```

#### Auto-thumbnail (most representative frame)

```bash
ffmpeg -i input.mp4 -vf 'thumbnail' -frames:v 1 thumbnail.png
ffmpeg -i input.mp4 -vf 'thumbnail=300' -frames:v 1 thumbnail-300.png
```

#### Frames with significant scene change

```bash
ffmpeg -i input.mp4 -vf 'select=gt(scene\,0.4)' -frames:v 5 -vsync vfr frames-diff-%02d.png
```

#### Add thumbnail to video as attachment

```bash
ffmpeg -i input.mp4 -i thumbnail.png -map 1 -map 0 \
 -c copy -disposition:0 attached_pic output.mp4
```

## Overlay (Picture-in-picture)

#### Image

```bash
ffmpeg -i input.mp4 -i image.png \
 -filter_complex \
 '[1:v]scale=480:854[overlay]; [0:v][overlay]overlay=0:0:enable="between(t,0,20)"' \
 -pix_fmt yuv420p -c:a copy \
 output.mp4
```

```bash
ffmpeg -i input.mp4 -i image.png \
 -filter_complex '[0:v][1:v] overlay=25:25:enable="between(t,0,20)"' \
 -pix_fmt yuv420p -c:a copy \
 output.mp4
```

```bash
ffmpeg -i input.mp4 -i image.png \
 -filter_complex '[0:v][1:v] overlay=W-w:H-h:enable="between(t,0,20)"' \
 -pix_fmt yuv420p -c:a copy \
 output.mp4
```

#### Video

```bash
todo
```

## Adjust playback speed

GIF specifes the time each frame is shown for in 1/100ths of a second,
meaning only a few frame rates can be represented exactly:

| 0.01s × |   FPS | Notes        |
| ------: | ----: | :----------- |
|       1 |   100 |              |
|       2 |    50 |              |
|       3 | 33.33 | ~30 (slowmo) |
|       4 |    25 | 25           |
|       5 |    20 |              |
|      10 |    10 |              |
|      20 |     5 |              |

A 30fps source (or every other frame of a 60fps source) can at best be represented in GIF
format in slight slow-motion at a frame rate of 33.33fps.

When converting to MP4, the original frame rate can be restored.

### 33.3333fps mp4 -> 30fps mp4

```bash
ffmpeg -i input.mp4 \
 -itsscale '1.1111111111111112' -map 0:0 -c:0 copy \
 -movflags '+faststart' -f mp4 -y output.mp4
```

### 33fps mp4 -> 30fps mp4

```bash
ffmpeg -i input.mp4 \
 -itsscale '1.1' -map 0:0 -c:0 copy \
 -movflags '+faststart' -f mp4 -y output.mp4
```

## Generate tiled snapshots

```bash
ffmpeg -i input.gif \
 -vf 'tile=10x1' -fps_mode passthrough -update 1 \
 output.tiled-snapshots.10x1.jpeg
```

## Trim (keyframes) from start

```bash
ffmpeg -ss '6.06600' -i input.mp4 \
 -avoid_negative_ts make_zero \
 -map '0:0' '-c:0' copy -map '0:1' '-c:1' copy \
 -movflags '+faststart' -f mp4 -y output.mp4
```

## Powershell

```ps1
ls | Where { $_.Extension -eq ".gif" } | ForEach {
ffmpeg -i $_.FullName -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -s 1920x1080 -sws_flags neighbor $_.Name.Replace(".gif", ".mp4")
Remove-Item $_}
```

## YouTube

    Progressive scan (no interlacing)
    High Profile
    2 consecutive B frames
    Closed GOP. GOP of half the frame rate.
    CABAC
    Variable bitrate. No bitrate limit is required, though we offer recommended bit rates below for reference
    Chroma subsampling: 4:2:0

- Content should be encoded and uploaded in the same frame rate it was recorded.

- Common frame rates include: 24, 25, 30, 48, 50, 60 frames per second (other frame rates are also acceptable).

- Interlaced content should be deinterlaced before uploading.

  - For example, 1080i60 content should be deinterlaced to 1080p30.
  - 60 interlaced fields per second should be deinterlaced to 30 progressive frames per second.

- The bitrates below are recommendations for uploads.
  - Audio playback bitrate is not related to video resolution.
  - To view new 4K uploads in 4K, use a browser or device that supports VP9.

### Recommended video bitrates for SDR uploads

| Type       | 24, 25, 30 FPS | 48, 50, 60 FPS  |
| ---------- | -------------- | --------------- |
| 8K         | 80 - 160 Mbps  | 120 to 240 Mbps |
| 2160p (4K) | 35–45 Mbps     | 53–68 Mbps      |
| 1440p (2K) | 16 Mbps        | 24 Mbps         |
| 1080p      | 8 Mbps         | 12 Mbps         |
| 720p       | 5 Mbps         | 7.5 Mbps        |
| 480p       | 2.5 Mbps       | 4 Mbps          |
| 360p       | 1 Mbps         | 1.5 Mbps        |

### Recommended video bitrates for HDR uploads

| Type       | 24, 25, 30 FPS | 48, 50, 60 FPS  |
| ---------- | -------------- | --------------- |
| 8K         | 100 - 200 Mbps | 150 to 300 Mbps |
| 2160p (4K) | 44–56 Mbps     | 66–85 Mbps      |
| 1440p (2K) | 20 Mbps        | 30 Mbps         |
| 1080p      | 10 Mbps        | 15 Mbps         |
| 720p       | 6.5 Mbps       | 9.5 Mbps        |
| 480p       | Not supported  | Not supported   |
| 360p       | Not supported  | Not supported   |

### Recommended audio bitrates for uploads

| Type   | Audio Bitrate |
| ------ | ------------- |
| Mono   | 128 kbps      |
| Stereo | 384 kbps      |
| 5.1    | 512 kbps      |

### YouTube recommends BT.709 as the standard color space for SDR uploads:

| Color Space | Color Transfer Characteristics (TRC) | Color Primaries        | Color Matrix Coefficients |
| ----------- | ------------------------------------ | ---------------------- | ------------------------- |
| BT.709      | BT.709 (H.273 value: 1)              | BT.709 (H.273 value 1) | BT.709 (H.273 value 1)    |

### Container: MP4

    No Edit Lists (or the video might not get processed correctly)
    moov atom at the front of the file (Fast Start)

### Audio codec: AAC-LC

    Channels: Stereo or Stereo + 5.1
    Sample rate 96khz or 48khz

<!-- vim: set ts=2 sw=2 conceallevel=2 nowrap: -->
