if exists("g:mayhem_loaded_winbar")
  finish
endif
let g:mayhem_loaded_winbar = 1

" let s:loaded = 'g:mayhem_loaded_'..substitute(expand('%:t:r'), '[^A-Za-z0-9-_]', '', 'g')
" if exists(s:loaded) | finish | else | exec 'let '..s:loaded..' = 1' | endif


" ═══╡ Dynamic WinBar menu ╞════════════════════════════════
"
" Related: CustomStatusline in ./statusline.vim
function! s:WinBarUpdate()
  silent nunmenu WinBar
  " tlunmenu WinBar
  if &diff
    " nunmenu WinBar | nnoremenu 1.10 WinBar.􀆧\ $dx\ \ 􀈄\ §de\ 􀈂\ §dt▕\ 􀆇\ [c▕\ 􀆈\ ]c▕\ 􀅌\ §dr <nop>
    silent nnoremenu 1.10 WinBar.􀆧\ $dx <Nop>
    silent nnoremenu 1.20 WinBar.􀈄\ §de\ ╱\ 􀈂\ §dt <Nop>
    silent nnoremenu 1.30 WinBar.􂨫\ [c\ ╱\ 􂨬\ ]c <Nop>
    silent nnoremenu 1.90 WinBar.􀅌\ §dr <Nop>
    " nunmenu WinBar | nnoremenu 1.10 WinBar.D・$dx:off・§de:get・§gt:put・[c:prv・]c:nxt <nop>
  elseif &ft == 'netrw'
    " nunmenu WinBar | nnoremenu 1.≀0 WinBar.Netrw・S:sort・I:layout・-:back・<S-B>:up・<S-W>:down・ <nop>
    "􀹲􀩳􀹆􀩼􀋱􀩳􁂷 􀹲 􀕹 􀩳 􀹆
    silent nnoremenu 1.10 WinBar.􀄼\ - <Nop>
    silent nnoremenu 1.20 WinBar.􀊬\ a\ 􀄬􀅍s,r\ 􀞖\ i <Nop>
    " silent nnoremenu 1.30 WinBar.‹B›􀄸􀄹‹W› <Nop>
    silent nnoremenu 1.60 WinBar.􀤰\ d <Nop>
    silent nnoremenu 1.70 WinBar.􀈑\ D <Nop>
    silent nnoremenu 1.80 WinBar.􀈎\ R <Nop>
    silent nnoremenu 1.90 WinBar.􀦍\ I <Nop>
    " silent nnoremenu 1.99 WinBar.􁹛  􂝖 􀅌􁊕􀊭 time􀐫 exten name size㎅㎆㎇<Nop>
  endif
  if &buftype == 'terminal'
    if mode() =~# 'n'
      silent nnoremenu 1.20 WinBar.􀊙\ ‹C-W›‹C-N› <nop>
    else
      silent nnoremenu 1.20 WinBar.􀊛\ ‹C️-W›︎‹︎C︎-N› <nop>
    endif
    " tlnoremenu 1.10 WinBar.􀯪􀱢・‹C-W›‹C-N›:・ <nop>
    "
    " register hints  􀭈􀆧
    "
    " nnoremenu 1.10 WinBar. <Nop>
    " nnoremenu 1.20 WinBar.􀉃‹+›\ 􀈿‹%›
    " nnoremenu 1.30 WinBar.last\ 􀠍‹/›\ 􀩼\ ‹:›\ 􀅫‹.›\ 􀆛‹-›
  endif
endfunc

command! WinBarUpdate call <SID>WinBarUpdate()

augroup winbar
  autocmd!

  au OptionSet diff call s:WinBarUpdate()
  au WinLeave,BufEnter,BufLeave,DiffUpdated,FileType * call s:WinBarUpdate()
  au ModeChanged *:nt,*:t* call s:WinBarUpdate()
augroup END
