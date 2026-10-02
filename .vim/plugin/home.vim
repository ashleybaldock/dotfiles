if exists("g:mayhem_loaded_home")
  finish
endif
let g:mayhem_loaded_home = 1


call autocmd_add([
      \#{
      \ event: 'VimEnter', pattern: '*',
      \ cmd: 'call home#onVimEnter()',
      \ group: 'mayhem_home_enter', once: v:true,
      \},
      \#{
      \ event: 'VimLeavePre', pattern: '*',
      \ cmd: 'call home#onVimLeavePre()',
      \ group: 'mayhem_home_exit', replace: v:true,
      \},
      \])

