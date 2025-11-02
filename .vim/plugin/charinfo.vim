if exists("g:mayhem_loaded_charinfo")
  finish
endif
let g:mayhem_loaded_charinfo = 1


"
" See: ../autoload/charinfo.vim
"

command! -bar -nargs=? CharInfo echo charinfo#formatForCommand(<q-args>)

nnoremap <silent><script> <Plug>(mayhem_charinfo) :<C-U>CharInfo<CR>

nnoremap <silent><script> <Plug>(mayhem_charinfo_toggle) :<C-U>Toggle g:mayhem_auto_charinfo<CR>

" exec 'an' SfIcon() '120.200.110' 'View.Chars.Auto\ Char\ Info' '<Cmd>Toggle g:mayhem_hl_auto_charinfo<CR>'


let g:mayhem_auto_charinfo = get(g:, 'mayhem_auto_charinfo', 0)

call mayhem#ObserveToggle('g:mayhem_auto_charinfo', #{
      \ states: #{
      \  0: #{ cmd: 'call autocmd_add([#{ event: ''CursorMoved'', pattern: ''*'', cmd: ''CharInfo'', group: ''mayhem_auto_charinfo''}])'},
      \  1: #{ cmd: 'silent! call autocmd_delete([#{ event: ''CursorMoved'', group: ''mayhem_auto_charinfo''}])'
      \}}}),

" call mayhem#ObserveToggle('g:mayhem_auto_charinfo', function('s:Update_AutoCharInfo()'))
" call s:Update_AutoCharInfo()

" call autocmd_add([
"       \#{
"       \ event: 'User', pattern: 'Toggle_g:mayhem_auto_charinfo',
"       \ cmd: 'call s:Update_AutoCharInfo()',
"       \ group: 'mayhem_update_auto_charinfo', replace: v:true,
"       \},
"       \])

