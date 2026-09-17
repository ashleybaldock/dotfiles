if exists("g:mayhem_loaded_cmdwin")
  finish
endif
let g:mayhem_loaded_cmdwin = 1

augroup mayhem_cmdwin
  autocmd CmdwinEnter :let b:mayhem_cmdwin = 1
  autocmd CmdwinEnter [:>=@-] :setlocal winhighlight+=!@:Directory
  autocmd CmdwinEnter [\/\?] :setlocal winhighlight+=!@:SpecialKey
  autocmd CmdwinEnter [\/\?] :setlocal ft=reg
augroup END
