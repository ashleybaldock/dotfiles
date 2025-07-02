
$ffmpeg="C:\Program Files\LosslessCut-win-x64\resources\ffmpeg.exe"
$sourceDir = "$($env:localAPPDATA)Low\Nolla_Games_Noita\save_rec\screenshots_animated\"
$convertedDir = Join-Path "$sourceDir" "_gifs_converted"

if (!(Test-Path -PathType container $convertedDir)) {
  New-Item -ItemType Directory -Path $convertedDir
}

ls | Where { $_.Extension -eq ".gif" } | ForEach { 
  $out = Join-Path "$sourceDir" $_.Name.Replace(".gif", ".mp4")

  & $ffmpeg -i $_.FullName -c:v libx264 -preset slow -crf 18 -movflags faststart -pix_fmt yuv420p \
   -vf "fps=30,scale=-2:1080:flags=neighbor" $out

  # & $ffmpeg -i $_.FullName -c:v libx264 -preset slow -crf 18 -movflags faststart -pix_fmt yuv420p \
  #  -itsscale='1.1111111111111112' -vf "scale=-2:1080:flags=neighbor" $out

  # & $ffmpeg -i $_.FullName -c:v libx264 -preset slow -crf 18 -movflags faststart -pix_fmt yuv420p \
  #  -itsscale='1.1111111111111112' -vf "fps=30,scale=-2:1080:flags=neighbor" $out

  Move-Item -Path $_.FullName -Destination $convertedDir
}


