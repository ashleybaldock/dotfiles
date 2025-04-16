if exists("g:mayhem_loaded_winbar")
  finish
endif
let g:mayhem_loaded_winbar = 1

let s:ruler = "╹𝟣\\ \\ \\ \\ \\ \\ \\ ╹𝟣𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟤𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟥𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟦𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟧𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟨𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟩𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟪𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟫𝟢\\ \\ \\ \\ \\ \\ \\ ╹𝟣𝟢𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟣𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟤𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟥𝟢\\ \\ \\ \\ \\ \\ ╹𝟣𝟦𝟢\\ \\ \\ \\ \\ ╹𝟣𝟧𝟢"

"
" ═══╡ Dynamic WinBar menu ╞════════════════════════════════
"
" Related: CustomStatusline in ./statusline.vim
function! s:WinBarUpdate()
  " If buffer has color columns and option to show in winbar is on
  if exists("b:mayhem_winbar_show_colcol")
    silent nunmenu WinBar

    " If signcolumn=yes or signcolumn=auto and is visible, can show index 1+
    " Otherwise if no signcolumn present, can show index 3+
    let colorcolumns = split(&l:colorcolumn, ',')

    silent nunmenu WinBar | exec 'silent nnoremenu 1.20 WinBar.' .. s:ruler .. ' <nop>'

    hi ToolbarLine    guifg=NONE    guibg=ysignsb gui=none
    hi ToolbarButton  guifg=#eeeeee guibg=ysignsb gui=none

    return
  endif
  " tlunmenu WinBar

  " Special cases
  "
  " 􀢤
  "
  " register hints  􀭈􀆧  TODO
  "
  " nnoremenu 1.10 WinBar. <Nop>
  " nnoremenu 1.20 WinBar.􀉃‹+›\ 􀈿‹%›
  " nnoremenu 1.30 WinBar.last\ 􀠍‹/›\ 􀩼\ ‹:›\ 􀅫‹.›\ 􀆛‹-›
  "
  if &buftype == 'terminal'
    " tlnoremenu 1.10 WinBar.􀯪􀱢・‹C-W›‹C-N›:・ <nop>
    silent nunmenu WinBar
    if mode() =~# 'n'
      silent nnoremenu 1.20 WinBar.􀊙\ ‹C-W›‹C-N› <nop>
    else
      silent nnoremenu 1.20 WinBar.􀊛\ ‹C️-W›︎‹︎C︎-N› <nop>
    endif
    return
  endif

  if &diff
    silent nunmenu WinBar
    " nnoremenu 1.10 WinBar.􀆧\ $dx\ \ 􀈄\ §de\ 􀈂\ §dt▕\ 􀆇\ [c▕\ 􀆈\ ]c▕\ 􀅌\ §dr <nop>
    silent nnoremenu 1.10 WinBar.􀆧\ $dx <Nop>
    silent nnoremenu 1.20 WinBar.􀈄\ §de\ ╱\ 􀈂\ §dt <Nop>
    silent nnoremenu 1.30 WinBar.􂨫\ [c\ ╱\ 􂨬\ ]c <Nop>
    silent nnoremenu 1.90 WinBar.􀅌\ §dr <Nop>
    return
  endif

  if &ft == 'netrw'
    silent nunmenu WinBar
    " nnoremenu 1.≀0 WinBar.Netrw・S:sort・I:layout・-:back・<S-B>:up・<S-W>:down・ <nop>
    silent nnoremenu 1.10 WinBar.􀄼\ - <Nop>
    silent nnoremenu 1.20 WinBar.􀊬\ a\ 􀄬􀅍s,r\ 􀞖\ i <Nop>
    " silent nnoremenu 1.30 WinBar.‹B›􀄸􀄹‹W› <Nop>
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
    silent nnoremenu 1.30 WinBar.􀀨\ p <Nop>

    return
  endif

  " Otherwise, no bar
  silent nunmenu WinBar
endfunc

command! WinBarUpdate call <SID>WinBarUpdate()

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

