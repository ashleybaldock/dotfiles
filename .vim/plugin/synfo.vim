if exists("g:mayhem_loaded_synfo")
  finish
endif
let g:mayhem_loaded_synfo = 1

"
" Related:
"   $VIMHOME/autoload/synfo.vim
"   $VIMHOME/notes/synfo-ui.md
"

command! -bar SynFo call <SID>SynFo()

command! SynFoBuf vsp|enew|call <SID>UpdateSynFoBuffer(winnr())

command! -nargs=? SynFoStatus call <SID> SynFoStatus(<f-args>)

command! -nargs=? SynFoAuto call <SID>SynFoEnable(<f-args>)

command! -nargs=? SynFoWindowOn call <SID>SynFoEnableInWindow(<f-args>)

command! -nargs=? SynFoWindowOff call <SID>SynFoDisableInWindow(<f-args>)

command! SynFoAllOff call <SID>SynFoDisableInAll()

command! -nargs=? SynFoWindowToggle call <SID>SynFoToggle(<f-args>)

