
$ffmpeg="C:\Program Files\LosslessCut-win-x64\resources\ffmpeg.exe"

ls | Where { $_.Extension -eq ".m2ts" } | ForEach {
  $out = $_.Name.Replace(".m2ts", ".mp4")
  & $ffmpeg -y -i $_.FullName -vcodec copy -acodec copy -f mp4 $out
  Remove-Item $_
}

