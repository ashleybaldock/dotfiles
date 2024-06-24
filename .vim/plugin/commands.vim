if exists("g:mayhem_loaded_commands")
  finish
endif
let g:mayhem_loaded_commands = 1

" find cursor                                       TODO
" highlight current cursor position by horizontal and vertical cursor
command! PingCursor <Nop>

function s:TempSetVirtualEditAll()
    let s:prevvirtualedit = &virtualedit
    set virtualedit=all
endfunc
function s:TempResetVirtualEdit()
    let &virtualedit = s:prevvirtualedit
endfunc

" screenrow screen row         (All 1-based)
" screencol screen column
" winid   Window ID of the click
" winrow  row inside winid
" wincol  column inside winid
" line    text line inside winid
" column  text column inside winid
" coladd  offset (in screen columns) from the
"          start of the clicked char
  " call winrestview({'curswant': pos.column + pos.coladd})
function s:StartVisualBlockFromClick()
  let pos = getmousepos()
  exec getwininfo(pos.winid)[0].winnr..'wincmd w'
  call cursor([pos.line, pos.column, pos.coladd, pos.column + pos.coladd])
  execute "normal! \<C-v>"
endfunc

function s:StartVisualBlockToClick()
  let pos = getmousepos()
  execute "normal! \<C-v>"
  call cursor([pos.line, pos.column, pos.coladd, pos.column + pos.coladd])
endfunc

command! StartVisualBlockFromClick call <SID>StartVisualBlockFromClick()
command! StartVisualBlockToClick call <SID>StartVisualBlockToClick()



command! RepeatMove call <SID>RepeatMove()
" 
function CursorOnComment()
  return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')) =~? 'comment'
endfunc
command! CursorOnComment echo CursorOnComment()


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
" Set a direction to move in after doing somthing
"
function! s:RepeatMove()
  let b:mayhem_move_after = get(b:, 'mayhem_move_after', 'normal l') 
  exec b:mayhem_move_after
endfunc


let s:directionMap = {
      \ 'none       ⥀⃝ ':          '',
      \ 'up       ↑⃝ ':            'normal k',
      \ 'upright    ↗︎⃝ ':       '',
      \ 'right       →⃝ ':         'normal l',
      \ 'downright  ↘︎⃝ ':     '',
      \ 'down     ↓⃝ ':      'normal j',
      \ 'downleft   ↙︎⃝ ':      '',
      \ 'upleft     ↖︎⃝ ':        '',
      \ 'up,left    ↑⃝ ,←⃝ ':    'normal kh',
      \ 'up,right   ↑⃝ ,→⃝ ':   'normal kl',
      \ 'right,up   →⃝ ,↑⃝  ': 'normal lk',
      \ 'right,down →⃝ ,↓⃝  ': 'normal lj',
      \ 'down,left  ↓⃝ ,←⃝ ': 'normal jh',
      \ 'down,right ↓⃝ ,→⃝ ': 'normal jl',
      \ 'left        ←⃝ ':   'normal h',
      \ 'left,up    ←⃝ ,↑⃝ ': 'normal hk',
      \ 'left,down  ←⃝ ,↓⃝ ': 'normal hj',
      \}
function! s:RepMoveComplete(ArgLead, CmdLine, CursorPos)
  return keys(s:directionMap)
  " return map(keys(s:directionMap), {_, val -> ''''..val..''''})
endfunc

command! -nargs=1 -complete=customlist,<SID>RepMoveComplete
      \ ChangeRepeatDirection 
      \ :let b:mayhem_move_after = s:directionMap[<q-args>]

command! RepeatMove call <SID>RepeatMove()

