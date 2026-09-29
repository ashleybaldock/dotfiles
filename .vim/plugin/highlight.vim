if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1

"
" Related:
"   $VIMHOME/autoload/highlight.vim
"   $VIMHOME/autoload/hi.vim
"

command! -bar HiHi call hi#hi()

nnoremap <silent><script> <Plug>(mayhem_hihi) <Cmd>call hi#hi()<CR>

nnoremap <silent><script> <Plug>(mayhem_nohihi) <Cmd>call hi#nohi()<CR>


command! -bar -nargs=? HighlightThis exec highlight#this(<q-args>)

nnoremap <silent><script> <Plug>(mayhem_hlgroup_hlthis) <Cmd>exec highlight#this()<CR>


command! -bar -nargs=? HlgroupExpand exec highlight#expand(<q-args>)

nnoremap <silent><script> <Plug>(mayhem_hlgroup_expand) <Cmd>exec highlight#expand()<CR>

command! -bar -nargs=? HlgroupDefine exec highlight#formatLastDefinedForCommandWithColor(<q-args>)

nnoremap <silent><script> <Plug>(mayhem_hlgroup_define) <Cmd>exec highlight#formatLastDefinedForCommandWithColor()<CR>
