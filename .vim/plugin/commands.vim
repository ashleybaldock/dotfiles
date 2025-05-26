if exists("g:mayhem_loaded_commands")
  finish
endif
let g:mayhem_loaded_commands = 1

 "" yank all matching lines to register
 " :let @a=""
 " :g/<pattern>/y A
 "" :echo @a
 "" copy register to clipboard
 " :let @*=@a

 "" delete all matching lines
 " :g/pattern/d
 " :g//d


" find cursor                                       TODO
" highlight current cursor position by horizontal and vertical cursor
" command! PingCursor <Nop>



" 
" Predicate: Cursor Is On A Comment
function CursorOnComment()
  return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')) =~? 'comment'
endfunc
command! CursorOnComment echo CursorOnComment()


" Set number column width based on length of file
" autocmd BufRead * let &l:numberwidth =
" \ max([float2nr(log10(line('$')))+3, &numberwidth]) 
"

"
" Util: Format numbers with SI prefixes in a
"       way that is pleasing to humans
"
function PrefixDecimal(n)
  let prefixes = ['', 'k', 'M', 'G', 'T']
  let cur = a:n
  let i = 0
  while cur > 1000 && i < len(prefixes) - 1
    let cur = cur / 1000.0
    let i = i + 1
  endwhile

  return printf("%4.1f%s", cur, prefixes[i])
endfunc


function FormatJSON(jsonString)
  return systemlist('npx prettier --stdin-filepath nameless.json', a:jsonString)
endfunc
"
" Apply code beautification to current
" contents of buffer (or part thereof)
"
function FormatBuffer(bufnr = bufnr()) range
  let l:filetype = &filetype
  let l:filename = expand('%')
  if ( l:filename != '' )
    let stdinpath = shellescape(l:filename)
  elseif ( l:filetype != '')
    let l:stdinpath = 'nameless.' .. l:filetype
  else
    let l:stdinpath = 'nameless.html'
  endif

  exec a:firstline .. ',' .. a:lastline .. '!npx prettier --stdin-filepath ' .. l:stdinpath
endfunc

"
" Transpose Rows And Columns: in range or visual selection
"
function! s:TransposeRowCol(sep='	') range abort
  exec a:firstline .. ',' .. a:lastline .. '!rs -T -g1 -C' .. a:sep
  exec line("'[") .. ',' .. line("']") .. 's/^\zs\s*//g'
endfunc
"
" Optional argument sets delimiter to insert between columns of output
" (defaults to <Tab>)
"
command! -nargs=? -range TransposeRowCol <line1>,<line2>call <SID>TransposeRowCol(<f-args>)

"
" Add line continutation (\⏎) to the current cursor line,
" or to the selected range of lines
" Can be given a specific column to wrap at (defaults 
" to cursor column)
" If used in an existing continuation block, reformats it   TODO
" to the new width
"
function Continuation(column) range
endfunc

"
" Remove line continuation from the continuation block
" the cursor is currently within, leaving a single line     TODO
" When called with a range, applies only to those
" lines (may affect multiple blocks, or only a part of one)
"
function Discontinuation() range
endfunc


" Information & Debug
"
augroup misc_commands
  autocmd!
  " Set readonly for specific directories
  au BufRead ~/noita/data* set readonly

  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  " Set syntax sync if file short enough
  au BufWinEnter * if (get(b:, 'linecount', 0) < get(g:, 'mayhem_sync_start_max_lines', 0)) | syn sync fromstart | endif
augroup END


command! WinSizeInfo echo win_execute(1077, 'echo ''window with id '' .. win_getid() .. '' has '' .. (line(''w$'') - line(''w0'') + 1) .. '' of '' .. line(''$'') .. '' lines visible, cursor is on line '' .. line(''.'') .. '', w0='' .. line(''w0'') .. '' ▬▶︎ w$='' .. line(''w$'')')


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
" function s:ReopenSessionInNewPane()
"   let pipe = shellescape(expand('$HOME/tmp/vimpipe'))
"   exec '!rm ' .. pipe
"   exec '!mkfifo ' .. pipe
"   exec '!open --env VFR="' .. shellescape(v:servername) .. '" -a ''/Applications/MacVim.app/Contents/bin/mvim'' --args -c ''echom get(environ(), "VFR", "UNKNOWN")'' -c ''so ' .. pipe .. ''''
"   exec 'mksession!' .. pipe
" endfunc

" command! MoveToNewPane :call <SID>ReopenSessionInNewPane()


function Todo()
  let todoCol = get(g:, 'mayhem_todo_align_column', 50)
  exec 'AlignLeftOnCol ' .. todoCol
endfunc

"
" V:
" Find common prefix of all lines and ignore it for sorting
" Balance sorted result across lines (including space for
" the common prefix)
" :
" Only sort selected section
" Keep prefix and suffix intact
" Balance results across original area
" If sorted output requires more lines, copy prefix + suffix
" from line sorted item came from
"
"        _____
" prefix│g i h│suffix    prefix a b c suffix 
" prefix│d f e│suffix    prefix d e f suffix 
" prefix│a c b│suffix    prefix g h i suffix 
"        ‾‾‾‾‾
"        _____       
" prefix│bbb i│suffix    prefix aaa   suffix
" prefix│dd ee│suffix    prefix bbb   suffix
" prefix│aaa g│suffix    prefix dd ee suffix
"        ‾‾‾‾‾           prefix g i   suffix
"                    
" 1. get list of the strings to sort
"  - yank selection into list, store each line's prefix + suffix
"    with the text to be sorted
"  - skip blank lines
" 

" skip z b e k d o z c f o e
" skip d d o w c r n v e o f
" skip x i w k o d p z p a x
" skip a f e s w p d w p d p

"
" Set a direction to move in after doing something
"
function! s:RepeatMove()
  " let b:mayhem_move_after = get(b:, 'mayhem_move_after', 'normal l') 
  let b:mayhem_move_after = get(b:, 'mayhem_move_after', 'call search(''\S'', ''W'', line(''.''))') 
  exec b:mayhem_move_after
endfunc


let s:directionMap = {
      \ 'line,skip,right': 'call search(''\S'', ''W'', line(''.''))',
      \ 'line,skip,left': 'call search(''\S'', ''bW'', line(''.''))',
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
  " return map(keys(s:directionMap), {_, val -> '''' .. val .. ''''})
endfunc

command! -nargs=1 -complete=customlist,<SID>RepMoveComplete
      \ ChangeRepeatDirection 
      \ :let b:mayhem_move_after = s:directionMap[<q-args>]

command! RepeatMove call <SID>RepeatMove()

