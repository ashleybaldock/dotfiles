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
		nunmenu WinBar
  if &diff
    " nunmenu WinBar | nnoremenu 1.10 WinBar.􀆧\ $dx\ \ 􀈄\ §de\ 􀈂\ §dt▕\ 􀆇\ [c▕\ 􀆈\ ]c▕\ 􀅌\ §dr <nop>
    nnoremenu 1.10 WinBar.􀆧\ $dx\ ╱g\ 􀈄\ §de\ ╱\ 􀈂\ §dt\ ╱\ 􀊉\ [c\ ╱\ 􀊋\ ]c\ ╱\ 􀅌\ §dr\ ╱ <Nop>
    " nunmenu WinBar | nnoremenu 1.10 WinBar.D・$dx:off・§de:get・§gt:put・[c:prv・]c:nxt <nop>
  elseif &ft == 'netrw'
    " nunmenu WinBar | nnoremenu 1.10 WinBar.Netrw・S:sort・I:layout・-:back・<S-B>:up・<S-W>:down・ <nop>
    "􀹲􀩳􀹆􀩼􀋱􀩳􁂷
    nnoremenu 1.10 WinBar.􀉌‹-› <Nop>
    nnoremenu 1.20 WinBar.􀵬\ ‹S›\ ╱\ 􀞖\ ‹i› <Nop>
    nnoremenu 1.30 WinBar.􀄨‹B›\ ╱\ 􀄩‹W› <Nop>
    nnoremenu 1.90 WinBar.􁜾\ ‹I› <Nop>
    nnoremenu 1.99 WinBar.􀈕 <Nop>
  " elseif ISTERMINAL == 'terminal' " TODO
  "   nunmenu WinBar | nnoremenu 1.10 WinBar.Netrw・S:sort・I:layout・-:back・<S-B>:up・<S-W>:down・ <nop>
    "
    " register hints
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
augroup END
