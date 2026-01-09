#!/usr/bin/osascript

use scripting additions
use application "Spotify"

# 􀊡􀊢􀊣􀊥􀊧􀊩
on volume()
  if sound volume is 0 then return "􀊠"
  if sound volume is less than 33 then return "􀊤 "
  if sound volume is less than 66 then return "􀊦 "
  if sound volume is less than 100 then return "􀊨"
end volume

on pad(x)
  if x is less than 10 then
    return "0" & x
  else 
    return x as string
  end if
end pad

on run argv
  set out to ""
  set command to "info"

  if count of argv is greater than 0 then
    if item 1 of argv is "data"
      set command to "data"
    else if item 1 of argv is "id"
      set command to "id"
    else
      set out to out & "Unrecognised command '" & item 1 of argv & "'\n"
    end if
  end if
      
  set trackName to name of current track
  set trackArtist to artist of current track
  set albumArtist to album artist of current track
  set trackAlbum to album of current track
  set trackPlayedCount to played count of current track
  set trackNumber to track number of current track
  set trackId to id of current track
  set trackArtworkUrl to artwork url of current track
  set trackUrl to spotify url of current track

  set trackDurationMilliseconds to duration of current track
  set playerPositionMilliseconds to round (player position * 1000) rounding down
  set remainingMilliseconds to (trackDurationMilliseconds - playerPositionMilliseconds)

  set trackMins to round ((trackDurationMilliseconds / 1000) / 60) rounding down
  set trackSeconds to round ((trackDurationMilliseconds / 1000) mod 60) rounding down
  set elapsedMins to round ((playerPositionMilliseconds / 1000) / 60) rounding down
  set elapsedSeconds to round ((playerPositionMilliseconds / 1000) mod 60) rounding down
  set remainingMins to round ((remainingMilliseconds / 1000) / 60) rounding down
  set remainingSeconds to round ((remainingMilliseconds / 1000) mod 60) rounding down

  set formattedTrackDuration to pad(trackMins) & ":" & pad(trackSeconds)
  set formattedElapsed to pad(elapsedMins) & ":" & pad(elapsedSeconds)
  set formattedRemaining to pad(remainingMins) & ":" & pad(remainingSeconds)
  set progressTime to pad(elapsedMins) & ":" & pad(elapsedSeconds) & "╶╴" & pad(trackMins) & ":" & pad(trackSeconds) 

  if command is "info"
    set out to out & "\n"
 # 􀊒  􀊎􀊊 􀩩 􀛷 􀊈  􀪆􀊆􀩫 􀊌 􀊐 􀊔
 # 􀊑  􀊍􀊉 􀩨 􀛶 􀊇  􀊃􀪅􀊅􀩪 􀊋 􀊏 􀊓 "
 #  & " ♪  􃐹 􃐺 􃄤 􃄥 􃊺 􃊻 􃂲 􃂳 􃐉  "
 #􀎌􀠕􀎏􀟽􀎐􁘤􀐱􀐯􃋐􀐫􁏏􀑪􃐹􃐺􀑪 

    if player state is "playing" then set out to out & "􀊄􀙫􃊸􃊹 𝚙𝚕𝚊𝚢𝚒𝚗𝚐 􀫀 "
    if not player state is "playing" then set out to out & "􀊆 𝚙𝚊𝚞𝚜𝚎𝚍 􃑓 "
    if shuffling then set out to out & " 􀊝 "
    if not shuffling then set out to out & "   "
    if repeating then set out to out & "􀊞 "
    if not repeating then set out to out & "   "
      set out to out & "(" & progressTime & ")"
    set out to out & "\n"
    set out to out & "\n    Artist  : " & trackArtist
    set out to out & "\n    Track 􀑬  " & trackName & " "
    set out to out & "\n    Album 􀢸  " & trackAlbum
    set out to out & "\n Duration 􃃂  " & formattedTrackDuration
    set out to out & "\n      URI 􀉣  " & spotify url of current track
  end if 

  if command is "data"
    if player state is "playing" then set out to out & "p1"
    if not player state is "playing" then set out to out & "p0"
    set out to out & ";s"
    if shuffling enabled then set out to out & "1,"
    if not shuffling enabled then set out to out & "0,"
    if shuffling then set out to out & "1"
    if not shuffling then set out to out & "0"
    set out to out & ";r"
    if repeating enabled then set out to out & "1,"
    if not repeating enabled then set out to out & "0,"
    if repeating then set out to out & "1"
    if not repeating then set out to out & "0"
    set out to out & ";t" & trackDurationMilliseconds & "," & playerPositionMilliseconds
    set out to out & ";v" & sound volume
  end if

  if command is "id"
    set out to out & spotify url of current track
  end if

  return out
  
end run
