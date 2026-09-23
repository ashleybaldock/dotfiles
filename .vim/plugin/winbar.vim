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
"
function! s:WinBarUpdate() abort
  silent nunmenu WinBar

  " No winbar for very small windows
  if winnr()->winheight() <= 5
    return
  endif

  " If buffer has color columns and option to show in winbar is on
  if exists("b:mayhem_winbar_show_colcol")
    " If signcolumn=yes or signcolumn=auto and is visible, can show index 1+
    " Otherwise if no signcolumn present, can show index 3+
    let colorcolumns = split(&l:colorcolumn, ',')->map({i, v -> str2nr(v)})
    let textoff = winnr()->getwininfo()->get(0)->get('textoff')

    exec 'silent nnoremenu 1.20 WinBar.' .. s:ruler .. ' <nop>'

    hi WinbarRulerLine    guifg=NONE    guibg=ysignsb gui=none
    hi WinbarRulerButton  guifg=#bbbbbb guibg=ysignsb gui=none

    setlocal winhighlight=ToolbarLine:WinbarRulerLine,ToolbarButton:WinbarRulerButton

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
  " ^w N   ^w️ N  ^️w️ N️  ^ｗN️
  "
  if &buftype == 'terminal'
    " tlnoremenu 1.10 WinBar.􀯪􀱢・‹️c️︎-️w︎›︎️‹︎️s︎-️n︎›️:・ <nop>
    if mode() =~# 'n'
      silent nnoremenu 1.20 WinBar.􀊙\ i <nop>
    else
      silent nnoremenu 1.20 WinBar.􀊛\ ^ｗN <nop>
    endif
    return
  endif

  if &buftype == 'quickfix'
    if get(b:, 'mayhem_quickfix_command', '') =~ '^:ag '
"    go  ╎ 􀬸 preview (maintain focus on results)
" o / O  ╎ 􀂒􀂓􀾘􀤳 open file / 􀏍􀃰 and close qf 􀆓􀄫 ⸺􀆊 􂚨 􀏠 ⸻􀆊􀆌􀏠 
" t / T  ╎ 􀏩 􀏪 … in a new tab / without moving to it  􀾮 􀾯 􀤴 􀤵 􀥞 􀥟 􀉘 􀶣 􀒐
" h / H  ╎ 􀧊 … in horizontal split / without moving to it         􀕰􀕱􀧋
" v / gv ╎ 􂨪􀏠 / ⃠⃯ →︎⃠ 􀏠 … in vertical split / without moving to it  􀧈􀘜􀧉
"     q  ╵ 􀃱􀏎 close the quickfix window
      " silent nnoremenu 1.05 WinBar.􀱢 <nop>
      silent nnoremenu 1.10 WinBar.􀆧\ §️︎q️︎ <nop>
      silent nnoremenu 1.20 WinBar.􀬸\ g️o️ <nop>
      silent nnoremenu 1.30 WinBar.􀏇\ o <nop>
      silent nnoremenu 1.40 WinBar.􀏩\ t <nop>
      silent nnoremenu 1.50 WinBar.􀧊\ h <nop>
      silent nnoremenu 1.60 WinBar.􀧈\ v <nop>
    endif
  endif

  if &diff
" nnoremenu 1.10 WinBar.􀆧\ $dx\ \ 􀈄\ §de\ 􀈂\ §dt▕\ 􀆇\ [c▕\ 􀆈\ ]c▕\ 􀅌\ §dr <nop>
"􀤴 􀤵 
    " if exists("b:mayhem_diff_left")
      " hi DiffVertSplit  guifg=yormalb guibg=yormalb gui=none
      " setlocal winhighlight+=!c:DiffVertSplit

      " silent nnoremenu 1.05 WinBar.􀐓\  <Nop>
      " silent nnoremenu 1.10 WinBar.􀆧\ $️︎d️︎x️︎ <Nop>

    " elseif exists("b:mayhem_diff_right")
    "   silent nnoremenu 1.05 WinBar.􀐔\  <Nop>
    " else
    "   silent nnoremenu 1.05 WinBar.􃜥\  <Nop>
    " endif

    if exists("b:mayhem_diff_left")
      silent nnoremenu 1.20 WinBar.􂨪\ \ } <Nop>
    elseif exists("b:mayhem_diff_right")
      silent nnoremenu 1.20 WinBar.􂨩\ \ { <Nop>
    else
      silent nnoremenu 1.20 WinBar.􀈄\ §de\ ╱\ 􀈂\ §dt <Nop>
    endif

    " silent nnoremenu 1.30 WinBar.􀄶􀄨􀄻􀄲\ [[\ ╱\ 􀄺􀄩􀄷􀄳\ ]] <Nop>
    silent nnoremenu 1.30 WinBar.􀄶\ [[\ ╱\ 􀄳\ ]] <Nop>
    silent nnoremenu 1.90 WinBar.􀅌\ §dr <Nop>
    return
  endif

  if &ft == 'netrw'
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
    silent nnoremenu 1.10 WinBar.􀤏\ - <Nop>
    silent nnoremenu 1.20 WinBar.􀅌\ r <Nop>
    silent nnoremenu 1.30 WinBar.􀋴\ p <Nop>
    silent nnoremenu 1.40 WinBar.􀠩\ t <Nop>

    return
  endif
endfunc

command! WinBarUpdate call <SID>WinBarUpdate()

function s:WinBarUpdateWindows(windows) abort
  " echon 'update windows... '
  for wid in a:windows
    " echon wid .. '... '
    call win_execute(wid, 'WinBarUpdate')
  endfor
endfunc

call autocmd_add([
      \#{
      \ event: 'OptionSet', pattern: 'diff,ft,buftype,colorcolumn',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_diff', replace: v:true,
      \},
      \#{
      \ event: 'ModeChanged', pattern: '*:nt,*:t*',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_mode', replace: v:true,
      \},
      \#{
      \ event: 'WinResized',
      \ pattern: '*', cmd: 'call s:WinBarUpdateWindows(v:event.windows)',
      \ group: 'mayhem_winbar_resize', replace: v:true,
      \},
      \#{
      \ event: ['WinEnter','WinLeave','BufEnter','BufLeave','DiffUpdated','FileType'],
      \ pattern: '*', cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'MayhemToggleColBar',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events_togglecolbar', replace: v:true,
      \},
      \])

