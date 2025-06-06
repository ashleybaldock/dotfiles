
$ffmpeg="C:\Program Files\LosslessCut-win-x64\resources\ffmpeg.exe"
$screenshots = "$HOME\AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots_animated\"
$converted = "_gifs_converted"


cd $screenshots
New-Item -ItemType Directory -Name $converted

ls | Where { $_.Extension -eq ".gif" } | ForEach { 
  $out = $_.Name.Replace(".gif", ".mp4")
  & $ffmpeg -i $_.FullName -preset slow -crf 18 -movflags faststart -pix_fmt yuv420p -vf "scale=-2:1080:flags=neighbor" $out
  Move-Item -Path $_.FullName -Destination $convertedDir
}


