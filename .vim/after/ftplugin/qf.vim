
"
" Related: ../../syntax/qf.vim
"          ../../plugin/quickfix.vim
"    $VIMRUNTIME/syntax/qf.vim
"

set quickfixtextfunc=QFTFAlignColumns

setlocal nowrap
syn on


" echo matchlist(w:quickfix_title, '^:' .. g:ackprg .. '\s*--\s*"\(.*\)"$')

function s:tally() abort
  let d = #{counts: {}}
  function d.count(key)
    let self.counts[a:key] = get(self.counts, a:key, 0) + 1
    return self
  endfunc
  function d.totals()
    return self.counts
  endfunc
  function d.unique()
    return keys(self.counts)->len()
  endfunc
  return d
endfunc

let qfl = getqflist(#{size: 0, title: 0, items: 0})

let resultcount = qfl.size
let filecount = reduce(qfl.items, { acc, item -> acc.count(item.bufnr)}, s:tally()).unique()
let qftitle = qfl.title

if exists('w:quickfix_title')
  " :Ack results (via ag, literal search)
  let searchterm = v:null
  if w:quickfix_title =~ '^:' .. g:ackprg .. ' -Q -- '
    let searchterm = get(matchlist(w:quickfix_title, '^:' .. g:ackprg .. ' -Q -- "\(.*\)"$'), 1, v:null)
  " :Ack results (via ag)
  elseif w:quickfix_title =~ '^:' .. g:ackprg
    let searchterm = get(matchlist(w:quickfix_title, '^:' .. g:ackprg .. ' \(.*\)$'), 1, v:null)
  endif

  echo matchadd('qfSearch', searchterm, 5)

  let b:mayhem_quickfix_subtype = 'ag'
  let b:mayhem_quickfix_search = searchterm
  let b:mayhem_quickfix_count = resultcount
  let b:mayhem_quickfix_filecount = filecount
  let b:mayhem_quickfix_command = qftitle

  " let b:mayhem_quickfix_title = '%#SlQfSepC#╱╱%* 􀊫 "' .. searchterm ..
  "       \ '" %#SlQfSepC#╱%* ' .. resultcount .. 
  "       \ ' result' .. (resultcount == 1 ? '' : 's') ..
  "       \ ' in ' .. filecount .. ' file' .. (filecount == 1 ? '' : 's') .. ' %#SlQfSepC#╱%* ' .. qftitle

  let &l:statusline = '%{%CustomStatusline()%}'

endif




" Only do this when not done yet for this buffer
" if exists("b:did_ftplugin")
"   finish
" endif
" b:did_ftplugin = 1

" wincmd K
" resize 8
" setlocal winfixheight
"
" pclose
" rightbelow vsplit pedit 
" resize 8
" setlocal winfixheight

" nnoremap <buffer><silent> p :rightbelow vsplit pedit<bar>.cc<bar>resize 8<bar>setlocal winfixheight<bar>setlocal nomodifiable<bar>wincmd h<CR>

" if mapcheck('<esc>', 'n') ==# ''
  " nnoremap <buffer><silent> <esc> <plug>(quickr_preview_qf_close)

  " nnoremap <leader>p <plug>(quickr_preview)
  " nnoremap <leader>q <plug>(quickr_preview_qf_close)
" endif

" open entry and come back
" nnoremap <silent> <buffer> o <CR><C-w>p

" open entry and close the location/quickfix window.
" let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)
" if b:qf_isLoc == 1
"   nnoremap <silent> <buffer> O <CR>:lclose<CR>
" else
"   nnoremap <silent> <buffer> O <CR>:cclose<CR>
" endif

" do something on each line in the location/quickfix list
" usage:
"   :Doline s/^/---
" command! -buffer -nargs=1 Doline call qf#do#DoList(1, <q-args>)

" do something on each file in the location/quickfix list
" usage:
"   :Dofile %s/^/---
" command! -buffer -nargs=1 Dofile call qf#do#DoList(0, <q-args>)

" Move forward and backward in list history (in a quickfix or location window)
" nnoremap <silent> <buffer> <Plug>(qf_older)         :<C-u>call qf#history#Older()<CR>
" nnoremap <silent> <buffer> <Plug>(qf_newer)         :<C-u>call qf#history#Newer()<CR>
" Jump to previous and next file grouping (in a quickfix or location window)
" nnoremap <silent> <buffer> <Plug>(qf_previous_file) :<C-u>call qf#filegroup#PreviousFile()<CR>
" nnoremap <silent> <buffer> <Plug>(qf_next_file)     :<C-u>call qf#filegroup#NextFile()<CR>
