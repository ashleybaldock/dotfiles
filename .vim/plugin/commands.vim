
" ╭──────────────────╮
" ╰─◯  Copy things   │
" ╭──────────────────╯
" │
" ╰─╴filesystem
" ╎   ├─▶︎ full path
:command! CopyPath let @+ = expand("%:p")
" ╎   ╰─▶︎ full path
:command! CopyFilename let @+ = expand("%:t")
" ╎
" ╰─╴git
" ╎   ├─▶︎ branch
:command! CopyGitBranch let @+ = FugitiveHead()
" ╎   ╰─▶︎ diff                                      TODO
:command! CopyGitDiff let @+ = 'TODO'
" ╎
" ╰─╴current buffer
" ╎   ├─▶︎ info                                      TODO
:command! CopyBufferInfo let @+ = 'TODO'
" ╎   ├─▶︎ contents                                  TODO
:command! CopyBuffer let @+ = 'TODO'
" ╎
" ╰─╴cursor
" ╎   ├─▶︎ unicode info from Characterize
:command!  -nargs=? CopyCharacterize redir @+>| Characterize <args> | redir END
" ╎   ├─▶︎ unicode char name                         TODO
" :command!  -nargs=? CopyCharacterize redir @+>| Characterize <args> | redir END
" ╎   ╰─▶︎ unicode info, character codepoint         TODO
:command! CopyCharCode let @+ = 'TODO'
" ╎
" ╰─▶︎ search
"     ╰─▶︎ last
:command! CopyLastSearch :let @+=@/



" find cursor                                       TODO
" highlight current cursor position by horizontal and vertical cursor
:command! PingCursor <Nop>


" 
function CursorOnComment()
  return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')) =~? 'comment'
endfunc
command! CursorOnComment :echo CursorOnComment()


" Information & Debug
"
augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  " Set syntax sync if file short enough
  au BufWinEnter * if (get(b:, 'linecount', 0) < get(g:, 'mayhem_sync_start_max_lines', 0)) | syn sync fromstart | endif

  " Use <esc> to close quickfix window
  " au FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
augroup END



" Window & Buffer debug info
"
function! s:FormatInfo()
  setlocal filetype=javascript
  call CocAction('format')
  setlocal filetype=mh_winfo
  setlocal nomodified nomodifiable
endfunc
:command! FormatInfo call <SID>FormatInfo()

function! s:WindowInfo(winid = win_getid())
  let wInfo = getwininfo(a:winid)
  let float = get(get(wInfo, 'variables', {}), 'float', 0)
  let bufnr = get(wInfo, 'bufnr', bufnr())
  let popOpts = float ? popup_getoptions(float) : ''

  let winInfo = [
        \ '// Window Info',
        \ wInfo,
        \ '// ------------------------------------'
        \]
  let popInfo = [
        \ '// popup options',
        \ popOpts,
        \ '// ------------------------------------'
        \]
  let bufinfo = [
        \ '// Buffer Info',
        \ getbufinfo(bufnr()),
        \ '// ------------------------------------'
        \]
  vsp
  enew
  call append('$', winInfo)
  call append('$', popInfo)
  call append('$', bufinfo)
  call s:FormatInfo()
endfunc

" Print window and buffer info into a split
" By default, uses current window, argument is ID of window
" to us otherwise
" Optionally takes ID of a different window
:command! -nargs=? Winfo call <SID>WindowInfo(<f-args>)

:command! WinfoLastCocFloat call <SID>WindowInfo(g:coc_last_float_win)


" Create a split if current buffer has modifications
" Useful to run before a command that may open a new buffer
" function! s:JumpTo(filepath, position)
  " 1. is file open in a window already? if so, use that
  " 2. is current window unsaved? if not, use this window
  " 3. open in split
  " if (&modified) 
  "   split filepath
  " else
  "   e filepath
  " endif
  " call setcursorcharpos(position)
  " m'
" endfunc
" command! -bar -nargs=+ -complete=file JumpTo :call <SID>JumpTo(<f-args>)

" function! s:SplitIfModified(...)
"   echom a:000
"   echom a:1
"   if (&modified) 
"     split a:000
"   else
"     e a:000
"   endif
" endfunc
" command! -bar -nargs=+ -complete=file SplitIfModified :call <SID>SplitIfModified(<f-args>)

  " !open '$VIMRUNTIME/../../../bin/mvim'           TODO
  "       \ --args -c 'delay 500m<CR>'
  "       \ -c 'echom testing<CR>'
  "       \ -c 'so /Users/ashley/tmp/vimpipe<CR>'
function s:ReopenSessionInNewPane()
  let pipe = shellescape(expand('$HOME/tmp/vimpipe'))
  exec '!rm '..pipe
  exec '!mkfifo '..pipe
  exec '!open --env VFR="'..shellescape(v:servername)..'" -a ''/Applications/MacVim.app/Contents/bin/mvim'' --args -c ''echom get(environ(), "VFR", "UNKNOWN")'' -c ''so '..pipe..''''
  exec 'mksession!'..pipe
endfunc

command! MoveToNewPane :call <SID>ReopenSessionInNewPane()


function! Todo()
  let todoCol = get(g:, 'mayhem_todo_align_column', 50)
  exec 'AlignLeftOnCol '..todoCol
endfunc


"
" 
"
function! s:RepeatMove()
  let g:mayhem_move_after = get(g:, 'mayhem_move_after', 'normal l') 
  exec g:mayhem_move_after
endfunc

command! RepeatMoveRight let g:mayhem_move_after = 'normal l'
command! RepeatMoveLeft  let g:mayhem_move_after = 'normal h'
command! RepeatMoveUp    let g:mayhem_move_after = 'normal k'
command! RepeatMoveDown  let g:mayhem_move_after = 'normal j'
command! RepeatMoveNot   let g:mayhem_move_after = ''
command! RepeatMove call <SID>RepeatMove()


"
"
"
function! s:GetCursorChar() abort
  return getline('.')[col('.')-1:-1]
endfunc

" Replaces the base character in a glyph made up of
" multiple characters (combining diacritics, 
" variation selectors etc.)
"
" Takes two arguments:
" 1. the replacement base character
" 2. (optional) the character to modify
"     - defaults to the character under the cursor
"       (this method doesn't change it)
"
" e.g. (B⃝ , C)  ▬▶︎ C⃝  
"
" No cleverness here, it just swaps the first character,
" will probably not work for some inputs
" 
function! ReplaceBaseChar(replacement, char = s:GetCursorChar()) abort
  return a:replacement..strpart(a:char, 1)
endfunc

    " s/\zs\(\%#\)\ze/\=s:ReplaceBaseChar(submatch(0))/n
command! -bar -nargs=+ ReplaceBase echo <SID>ReplaceBaseChar(<q-args>)

let g:mayhem_combining_diacriticals = [ ['\u20d0'] ]
"                                                           TODO
" Combine a char with various diacritical marks
" Shows a popup with the results
"
function! s:GenerateCombinings(arg) abort
  let parts = s:SplitChar(a:arg)
  let base = parts[0]
  echom s:SplitChar(a:arg)
endfunc

command! -bar -nargs=? GenerateCombinings call <SID>GenerateCombinings(<q-args>)

"                                                           TODO
" Cycle through predefined sets of Unicodepoints
" 
" A given codepoint may have more than one dimension
" along which it can be cycled
" 
" e.g. ┼ ▬▶︎ ├ ▬▶︎ ┌ ▬▶︎ ┬ ▬▶︎ ┐ ▬▶︎ ┤ ▬▶︎ ┘ ▬▶︎ ┴ ▬▶︎ └ 
" rotation
"      ┘ ▶︎ ╴ ▶︎ ┐ ▶︎ ╷ ▶︎ ┌ ▶︎ ╶ ▶︎ └ ▶︎ ╵   ▮◀︎ 
"      │ ▶︎ ╱ ▶︎ ─ ▶︎ ╲   ⏮
" style
"      ┘ ▶︎ ┙ ▶︎ ┚ ▶ ┛ ▶ ╛ ▶ ╜ ▶ ╝ ▶ ╯  ▮◀︎◀︎
"      
"
let g:mayhem_unicycles = [
      \ ['', '', '╭', '','╮', '','╯','', '╰'],
      \ ['┼','├','┌','┬','┐','┤','┘','┴','└'],
      \ ['╋','┣','┏','┳','┓','┫','┛','┻','┗'],
      \ ['╬','╠','╔','╦','╗','╣','╝','╩','╚'],
      \ ['╴','─','╶','╌','┄','┈','╼','╾'],
      \ ['╸','━','╺','╍','┅','┉'],
      \ ['╵','│','╷','╎','┆','┊','╽','╿'],
      \ ['╹','┃','╻','╏','┇','┋'],
      \ ['╱','╲','╳']
      \ ]
function! s:CycleChars(arg) abort
  " find base char
  let parts = s:SplitChar(a:arg)
  " check cycle arrays for combined, and then base
endfunc

