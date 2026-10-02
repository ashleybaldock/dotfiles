if exists("g:mayhem_loaded_home")
  finish
endif
let g:mayhem_loaded_home = 1


call autocmd_add([
      \#{
      \ event: 'VimEnter', pattern: '*',
      \ cmd: 'call s:OnVimEnter()',
      \ group: 'mayhem_home_enter', once: v:true,
      \},
      \#{
      \ event: 'VimLeavePre', pattern: '*',
      \ cmd: 'call s:OnVimLeavePre()',
      \ group: 'mayhem_home_exit', replace: v:true,
      \},
      \])

