if exists("g:mayhem_loaded_winbar")
  finish
endif
let g:mayhem_loaded_winbar = 1

" let s:ruler = '𝟢╹𝟣 \ \ \ \ \ \ ╹𝟣\ \ \ \ \ \ \ ╹𝟤𝟢\ \ \ \ \ \ \ ╹𝟥𝟢\ \ \ \ \ \ \ ╹𝟦𝟢\ \ \ \ \ \ \ ╹𝟧𝟢\ \ \ \ \ \ \ ╹𝟨𝟢\ \ \ \ \ \ \ ╹𝟩𝟢\ \ \ \ \ \ \ ╹𝟪𝟢\ \ \ \ \ \ \ ╹𝟫𝟢\ \ \ \ \ \ \ ╹𝟣𝟢𝟢\ \ \ \ \ \ ╹𝟣𝟣𝟢\ \ \ \ \ \ ╹𝟣𝟤𝟢\ \ \ \ \ \ ╹𝟣𝟥𝟢\ \ \ \ \ \ ╹𝟣𝟦𝟢\ \ \ \ \ ╹𝟣𝟧𝟢'
" let s:ruler = '╹𝟣\\ \\ \\ \\ \\ \\ \\ ╹𝟣𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟤𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟥𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟦𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟧𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟨𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟩𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟪𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟫𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟣𝟢𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟣𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟤𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟥𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟦𝟢\\ \\ \\ \\ \\ ╹𝟣𝟧𝟢'
let s:ruler = '\ \ \ \ \ \ \ \ ╵¹\ \ \ \ \ \ \ ╵²\ \ \ \ \ \ \ ╵³\ \ \ \ \ \ \ ╵⁴\ \ \ \ \ \ \ ╵⁵\ \ \ \ \ \ \ ╵⁶\ \ \ \ \ \ \ ╵⁷\ \ \ \ \ \ \ ╵⁸\ \ \ \ \ \ \ ╵⁹\ \ \ \ \ \ \ ╵¹⁰\ \ \ \ \ \ ╵¹¹\ \ \ \ \ \ ╵¹²\ \ \ \ \ \ ╵¹³\ \ \ \ \ \ ╵¹⁴\ \ \ \ \ ╵¹⁵'

"
" ═══╡ Dynamic WinBar menu ╞════════════════════════════════
"
" Related: CustomStatusline in ./statusline.vim
function! s:WinBarUpdate()
  let winheight = winheight(winnr())

  " echom 'winnr: ' .. winnr() .. ' h:' .. winheight

  " No winbar for very small windows
  if winheight < 3
    silent nunmenu WinBar
    return
  elseif winheight == 3
    return
  endif

  " If buffer has color columns and option to show in winbar is on
  if exists("b:mayhem_winbar_show_colcol")
    silent nunmenu WinBar

    " If signcolumn=yes or signcolumn=auto and is visible, can show index 1+
    " Otherwise if no signcolumn present, can show index 3+
    let colorcolumns = split(&l:colorcolumn, ',')

    silent nunmenu WinBar | exec 'silent nnoremenu 1.20 WinBar.' .. s:ruler .. ' <nop>'

    hi ToolbarLine    guifg=NONE    guibg=ysignsb gui=none
    hi ToolbarButton  guifg=#bbbbbb guibg=ysignsb gui=none

    return
  endif
  " tlunmenu WinBar

  " Special cases
  "
  " 􀢤
  "
  " 􀕴􀕵􀧺􀧻􀣮􀣯􀪵􀪶􀮋􁓓􀮌􂼼 􀮞􀮟
  "
  " register hints  􀭈􀆧  TODO
  "
  " nnoremenu 1.10 WinBar. <Nop>
  " nnoremenu 1.20 WinBar.􀉃‹️+️›️\ 􀈿‹️%︎›️
  " nnoremenu 1.30 WinBar.last\ 􀠍‹️/︎›️\ 􀩼\ ‹️:️›️\ 􀅫‹️.️›️\ 􀆛‹️-️›️
  "
  if &buftype == 'terminal'
    " tlnoremenu 1.10 WinBar.􀯪􀱢・‹️c️︎-️w︎›︎️‹︎️s︎-️n︎›️:・ <nop>
    silent nunmenu WinBar
    if mode() =~# 'n'
      silent nnoremenu 1.20 WinBar.􀊙\ ‹️c️︎-️w︎›︎️‹︎️s︎-️n︎›️ <nop>
    else
      silent nnoremenu 1.20 WinBar.􀊛\ ‹️c️︎-️w︎›︎️‹︎️s︎-️n︎›️ <nop>
    endif
    return
  endif

  if &buftype == 'quickfix'
    silent nunmenu WinBar
    if 'is Ack'

      "    go  ╎ 􀬸 preview (maintain focus on results).
      " o / O  ╷ 􀂒􀂓􀾘􀤳 open file / 􀏍􀃰 and close qf  
      " t / T  ╎ 􀏩 􀏪 … in a new tab / without moving to it  􀾮􀾯􀤴􀤵􀥞􀥟􀶣􀉘􀒐
      " h / H  ╎ 􀕰􀧊􀕱􀧋  … in horizontal split / without moving to it
      " v / gv ╎ 􀏠􀧈􀘜􀧉  … in vertical split / without moving to it
      "     q  ╵ 􀃱􀏎 close the quickfix window.
      silent nnoremenu 1.20 WinBar.􀱢\ ‹️c️︎-️w︎›︎️‹︎️s︎-️n︎›️ <nop>
    endif
  endif

  if &diff
    silent nunmenu WinBar
    " nnoremenu 1.10 WinBar.􀆧\ $dx\ \ 􀈄\ §de\ 􀈂\ §dt▕\ 􀆇\ [c▕\ 􀆈\ ]c▕\ 􀅌\ §dr <nop>
    "􀤴\ 􀤵\ 
      silent nnoremenu 1.05 WinBar.􀆧\ $dx <Nop>
    if exists("b:mayhem_diff_left")
      silent nnoremenu 1.20 WinBar.􂨪\ \ 􀆝] <Nop>
    elseif exists("b:mayhem_diff_right")
      silent nnoremenu 1.20 WinBar.􂨩\ \ 􀆝[ <Nop>
    else
      silent nnoremenu 1.20 WinBar.􀈄\ §de\ ╱\ 􀈂\ §dt <Nop>
    endif
    " silent nnoremenu 1.30 WinBar.􀄶􀄨􀄻􀄲\ [[\ ╱\ 􀄺􀄩􀄷􀄳\ ]] <Nop>
    silent nnoremenu 1.30 WinBar.􀄶\ [[\ ╱\ 􀄳\ ]] <Nop>
    silent nnoremenu 1.90 WinBar.􀅌\ §dr <Nop>
    retur
  endif

  if &ft == 'netrw'
    silent nunmenu WinBar
    " nnoremenu 1.≀0 WinBar.Netrw・S:sort・I:layout・-:back・‹︎️s︎-️b︎›️:up・‹︎️s︎-️w›️:down・ <nop>
    silent nnoremenu 1.10 WinBar.􀄼\ - <Nop>
    silent nnoremenu 1.20 WinBar.􀊬\ a\ 􀄬􀅍s,r\ 􀞖\ i <Nop>
    " silent nnoremenu 1.30 WinBar.‹️B︎›️􀄸􀄹‹️W︎›️ <Nop>
    silent nnoremenu 1.60 WinBar.􀤰\ d <Nop>
    silent nnoremenu 1.70 WinBar.􀈑\ D <Nop>
    silent nnoremenu 1.80 WinBar.􀈎\ R <Nop>
    silent nnoremenu 1.90 WinBar.􀦍\ I <Nop>
    return
    " silent nnoremenu 1.99 WinBar.􁹛  􀅌 􁊕 􀊭 time􀐫 exten name size㎅㎆㎇<Nop>
    "􀹲􀩳􀹆􀩼􀋱􀩳􁂷 􀹲 􀕹 􀩳 􀹆
  endif

  if &ft == 'vimmessages'
    silent nunmenu WinBar
    silent nnoremenu 1.10 WinBar.􀤏\ - <Nop>
    silent nnoremenu 1.20 WinBar.􀅌\ r <Nop>
    silent nnoremenu 1.30 WinBar.􀋴\ p <Nop>
    silent nnoremenu 1.40 WinBar.􀠩\ t <Nop>

    return
  endif

  " Otherwise, no bar
  silent nunmenu WinBar
endfunc

command! WinBarUpdate call <SID>WinBarUpdate()

function s:WinBarUpdateWindows(windows) abort
  echon 'update windows... '
  for wid in a:windows
    echon wid .. '... '
    call win_execute(wid, 'WinBarUpdate')
  endfor
endfunc

call autocmd_add([
      \#{
      \ event: 'OptionSet', pattern: 'diff',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events', replace: v:true,
      \},
      \#{
      \ event: 'ModeChanged', pattern: '*:nt,*:t*',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events', replace: v:true,
      \},
      \#{
      \ event: 'WinResized',
      \ pattern: '*', cmd: 'call s:WinBarUpdateWindows(v:event.windows)',
      \ group: 'mayhem_winbar_events', replace: v:true,
      \},
      \#{
      \ event: ['WinEnter','WinLeave','BufEnter','BufLeave','DiffUpdated','FileType'],
      \ pattern: '*', cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'MayhemToggleColBar',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events', replace: v:true,
      \},
      \])

