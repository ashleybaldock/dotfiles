if exists("g:mayhem_loaded_home")
  finish
endif
let g:mayhem_loaded_home = 1


augroup home
  autocmd VimEnter    * nested call s:OnVimEnter()
  autocmd VimLeavePre * nested call s:OnVimLeavePre()
augroup END


function! s:OnVimEnter()
  if !argc() && line('$') == 1 && getline('.') == ''
    if get(g:, 'autoload_session') && filereadable('Session.vim')
      source Session.vim
    endif
  endif

  call map(v:oldfiles, 'fnamemodify(v:val, ":p")')
  autocmd BufNewFile,BufRead,BufFilePre *
        \ call s:update_recently_edited(expand('<afile>:p'))
endfunction

function! s:OnVimLeavePre()
endfunction
