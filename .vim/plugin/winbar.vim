if exists("g:mayhem_loaded_winbar")
  finish
endif
let g:mayhem_loaded_winbar = 1

"
" ═══╡ Dynamic WinBar menu ╞════════════════════════════════
"
" Related: CustomStatusline in ./statusline.vim
function! s:WinBarUpdate()
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

    return
  endif
endfunc

command! WinBarUpdate call <SID>WinBarUpdate()

call autocmd_add([
      \#{
      \ event: 'OptionSet', pattern: 'diff',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events',replace: v:true,
      \},
      \#{
      \ event: 'ModeChanged', pattern: '*:nt,*:t*',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events',replace: v:true,
      \},
      \#{
      \ event: ['WinLeave','BufEnter','BufLeave','DiffUpdated','FileType'],
      \ pattern: '*',
      \ cmd: 'call s:WinBarUpdate()',
      \ group: 'mayhem_winbar_events',replace: v:true,
      \},
      \])

" augroup winbar
"   autocmd!

"   au OptionSet diff call s:WinBarUpdate()
"   au WinLeave,BufEnter,BufLeave,DiffUpdated,FileType * call s:WinBarUpdate()
"   au ModeChanged *:nt,*:t* call s:WinBarUpdate()
" augroup END
" 
" 
