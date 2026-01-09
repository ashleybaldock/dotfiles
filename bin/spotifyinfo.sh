#!/usr/bin/osascript

use scripting additions
use application "Spotify"

# 􀊒  􀊎􀊊 􀩩 􀛷 􀊈  􀪆􀊆􀩫 􀊌 􀊐 􀊔  􀊛􀊘􀊕􀊖─􀵉􀵊
# 􀊑  􀊍􀊉 􀩨 􀛶 􀊇  􀊃􀪅􀊅􀩪 􀊋 􀊏 􀊓 
#    􃄤  􃄥  􃊺  􃊻  􃂲  􃂳  􃐉        􀲏 􂃓  
#   􂺷  􂺸  􀋂  􀋅  􀋆  􀠧 􀠨 􀑭   􀅳􀅴 􀅵 􁊇 􁊈
# 􀎌 􀠕 􀎏 􀟽 􀎐 􀐱 􀐯 􃋐  􀐫  􀑪 􃐹  􃐺  􀑪 
# 􃊸 􁏏􀙫 􃊹 􃊸 
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

on formatTime(ms)
  return pad(round ((ms / 1000) / 60) rounding down) & ":" & pad(round ((ms / 1000) mod 60) rounding down)
end formatTime

on formatProgress(remaining, duration)
  return "(" & formatTime(remaining) & "╶╴" & formatTime(duration) & ")"
end formatProgress

# on formatStarred()
#   if starred of current track then
#     return "􀋂 "
#   else
#     return "  "
#   end if
# end formatStarred

on formatStatus()
  if player state is playing then return " 􀊃 𝚙𝚕𝚊𝚢𝚒𝚗𝚐 􀫀 "
  if player state is paused then return " 􀊅 𝚙𝚊𝚞𝚜𝚎𝚍  􃑓 "
  if player state is stopped then return " 􀛶 𝚜𝚝𝚘𝚙𝚙𝚎𝚍 􃑓 "
end formatStatus

on formatRepeating()
  if repeating then
    return "􀊞  "
  else
    return "    "
  end if
end formatRepeating

on formatShuffling()
  if shuffling then
    return "􀊝  "
  else
    return "    "
  end if
end formatShuffling

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
      
  set trackArtist to artist of current track
  set trackAlbum to album of current track
  set trackDiscNumber to disc number of current track
  set trackDuration to duration of current track
  set trackPlayedCount to played count of current track
  set trackNumber to track number of current track
  # set trackStarred to starred of current track
  set trackPopularity to popularity of current track
  # set trackId to id of current track
  set trackName to name of current track
  # set trackArtworkUrl to artwork url of current track
  set trackAlbumArtist to album artist of current track
  set trackSpotifyUrl to spotify url of current track

  # All in ms
  set playerState to player state
  set playerPosition to round (player position * 1000) rounding down
  set playerTrackRemaining to (trackDuration - playerPosition)

  if command is "info"
    # if playerState is not paused then set out to (out & "playing!")
    # if playerState is not playing then set out to (out & "paused!")

    set out to (out &     "┎───────────────􀫀 ╶╴𝚂𝚙𝚘𝚝𝚒𝚏𝚢╶╴􀊗 ╶╴􀊝 ╶───────────────────")
    set out to (out &   "\n┎───􀫀 ╶╴𝚂𝚙𝚘𝚝𝚒𝚏𝚢╶╴╶╴􀊝 ╶───────────────────")
    set out to (out &   "\n┃ ‹️𝟢𝟣:𝟤𝟥›️╍╍╍╍╍╍╍╍╍􀊕 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄‹️-️𝟢𝟤:𝟢𝟧›️ ")
    set out to (out & "\n┃")
    set out to (out & formatStatus() & formatRepeating() & formatShuffling())
    set out to (out & formatProgress(playerTrackRemaining, trackDuration))
    if trackName is trackAlbum then
      set out to (out & "\n┃   􀑬  " & trackName)
      set out to (out & "\n┃   ᵇʸ 􀲏  " & trackArtist)
    else 
      set out to (out & "\n┃ 𝚝𝚛𝚊𝚌𝚔 􀑬 " & trackNumber & "   " & trackName)
      set out to (out & "\n┃ 𝚘𝚏 𝚊𝚕𝚋𝚞𝚖 􃐹  " & trackAlbum)
      set out to (out & "\n┃ 𝚏𝚛𝚘𝚖 𝚊𝚕𝚋𝚞𝚖 􃐹  " & trackAlbum)
    end if
    set out to (out &   "\n┃   Artist 􂃓   " & trackArtist)
    set out to (out &   "\n┃ Duration 􃃂   " & formatTime(trackDuration))
    set out to (out &   "\n┃      URI 􀉣  " & spotify url of current track)
    set out to (out &   "\n┃ Alb.Artist   " & trackAlbumArtist)
    set out to (out &   "\n┠─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴─╴")
    set out to (out &   "\n┃    Plays     " & trackPlayedCount)
    set out to (out &   "\n┃ Popularity   " & trackPopularity)
    set out to (out &   "\n┃   Disc # 􀢸  " & trackDiscNumber)
    set out to (out &   "\n┖──────────────────────────────────────────────────")
  end if 

  if command is "data"
    set out to out & "p"
    if player state is playing then set out to out & "1"
    if not player state is playing then set out to out & "0"
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
    set out to out & ";t" & trackDuration & "," & playerPosition
    set out to out & ";v" & sound volume
  end if

  if command is "id"
    set out to out & trackSpotifyUrl
  end if

  return out
  
end run
