
$ffmpeg="C:\Program Files\LosslessCut-win-x64\resources\ffmpeg.exe"
$ffargs=" -hide_banner -loglevel error"


$sourceDir="$($env:localAPPDATA)Low\Nolla_Games_Noita\save_rec\screenshots_animated\"
$convertedDir=Join-Path "$sourceDir" "_gifs_convertedT"


if (!(Test-Path -PathType container $convertedDir)) {
  New-Item -ItemType Directory -Path $convertedDir
}

$n=0

ls $sourceDir | Where { $_.Extension -eq ".gif" } | ForEach { 
  $n = $n + 1

  Write-Host ""
  Write-Host "----------------------------------$n--------------------------------"
  Write-Host ""

  $srcgif = $_.FullName
  $out = Join-Path "$sourceDir" $_.Name.Replace(".gif", "-fps30.mp4")

  Write-Host "-: 1 :------/ 'fps=30' /----------------------------"
  Write-Host "1: gif('$srcgif') -> mp4('$out')"
  & $ffmpeg -hide_banner -loglevel error -stats -i $srcgif -c:v libx264 -preset slow -crf 18 -movflags faststart -pix_fmt yuv420p -vf "scale=-2:1080:flags=neighbor,fps=30" $out


  Write-Host "-: 2 :------/ '-r 30' /-----------------------------"
  Write-Host "gif('$srcgif') -> mp4('$out')"
  $scaled = Join-Path "$sourceDir" $_.Name.Replace(".gif", "-ups.mp4")

  & $ffmpeg -hide_banner -loglevel error -stats -r 30 -i $srcgif -c:v libx264 -preset slow -crf 18 -movflags faststart -pix_fmt yuv420p -vf "scale=-2:1080:flags=neighbor" $scaled



  $tmpdir = Join-Path "$sourceDir" $_.Name.Replace(".gif", "-tmp")
  $tmppat = Join-Path "$tmpdir" "frame_%d.png"
  $frames = Join-Path "$sourceDir" $_.Name.Replace(".gif", "-frames.mp4")

  if (Test-Path -PathType container $tmpdir) {
    Write-Warning "Temp dir for frames '$tmpdir' exists already"

  } else {

    New-Item -ItemType Directory -Path "$tmpdir"

    & $ffmpeg -hide_banner -loglevel error -stats -i "$srcgif" "$tmppat"

    Write-Host ""
    Write-Host "-: 3 :------/ 'image2' /---------------------------"
    Write-Host "gif('$srcgif') -> mp4('$out')"
    & $ffmpeg -hide_banner -loglevel error -stats -framerate 30 -pattern_type sequence -i "$tmppat" -c:v libx264 -preset slow -crf 18 -movflags faststart -pix_fmt yuv420p -vf "scale=-2:1080:flags=neighbor" $frames

  }
}


