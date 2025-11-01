if exists("g:mayhem_loaded_commands")
  finish
endif
let g:mayhem_loaded_commands = 1


"
" Find similar matching lines and move them to cursor location
"
function! Gather(pat, bufnr = bufnr(), to = '$') range abort
  " let l = @l
  " let @l = ''
  " let restore_l = getreginfo()
  " call setreg('l', [], '')
  " exec a:firstline .. a:lastline .. '%g/' .. a:pat .. '/d L'

  if a:firstline == a:lastline
    let fromline = 1
    let toline = '$'
  else
    let fromline = a:firstline
    let toline = a:lastline
  endif

  " get matching lines before and after 'to' position
  " if 'to' position is a matching line
  "  - insert before matches just before it
  "  - append after matches just after it
  " if 'to' position is not a matching line
  "  - insert 'before' matches just before
  "   - place cursor on the last 'before' match
  "  - append 'after' matches just after
  "
  "  thus the cursor ends up in the middle of the gathered
  "  matches, at the same relative position to them as they
  "  were in the file before gathering

  let matches = matchbufline(a:bufnr, a:pat, fromline, toline)
  echom matches
  let matchedlines = mapnew(matches, {i,m -> getbufline(a:bufnr, m.lnum)[0]})
  echom matchedlines
  call reverse(matches)
        \->foreach({i,m -> deletebufline(a:bufnr, m.lnum)})
  
  call appendbufline(a:bufnr, a:to, matchedlines)
  " let gathered = map(matchedlines, {i,l -> })
  " let str = getreg('l', 1, 0)
  " let list = getreg('l', 1, 1)
  " let @l = l
endfunc
" Highlight entire tab that cursor is in
"echo matchadd('Error', '\%#	', 2)


" yank all matching lines to register
"> :let @a=""
"> :g/<pattern>/y A
"> :echo @a
" copy register to clipboard
"> :let @*=@a

"" delete all matching lines
" :g/pattern/d
" :g//d


let s:seqtoggles = {
      \'true':'false',
      \'false':'true',
      \}
" Return next string from predefined sequences
" e.g. 'true' -> 'false', 'false' -> 'true'
function SequenceToggleNext(word = expand('<cword>')) abort
  if has_key(s:seqtoggles, a:word)
    call substitute('\<\S\{-}\%#\S\{-}\>', s:seqtoggles[a:word], 'g')
  else
  endif
endfunc



" find cursor                                       TODO
" highlight current cursor position by horizontal and vertical cursor
" command! PingCursor <Nop>

" 
" Predicate: Cursor Is On A Comment
command! CursorOnComment echo predicate#cursorIsOnComment()


" Set number column width based on length of file
" autocmd BufRead * let &l:numberwidth =
" \ max([float2nr(log10(line('$')))+3, &numberwidth]) 
"

"
" Util: Format numbers with SI prefixes in a
"       way that is pleasing to humans
"
function PrefixDecimal(n) abort
  let prefixes = ['', 'k', 'M', 'G', 'T']
  let cur = a:n
  let i = 0
  while cur > 1000 && i < len(prefixes) - 1
    let cur = cur / 1000.0
    let i = i + 1
  endwhile

  return printf("%4.1f%s", cur, prefixes[i])
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
function Continuation() range
endfunc

"
" Remove line continuation from the continuation block
" the cursor is currently within, leaving a single line     TODO
" When called with a range, applies only to those
" lines (may affect multiple blocks, or only a part of one)
"
function Discontinuation() range
endfunc

xnoremap <unique> <silent><script> <Plug>(mayhem_continuation) <ScriptCmd>call Continuation()<CR>
xnoremap <unique> <silent><script> <Plug>(mayhem_discontinuation) <ScriptCmd>call Discontinuation()<CR>


" Information & Debug
"
call autocmd_add([
      \#{
      \ event: 'BufRead', pattern: '~/noita/data*',
      \ cmd: 'set readonly nomodifiable',
      \ group: 'mayhem_misc_bufreadonly', replace: v:true,
      \},
      \#{
      \ event: 'BufEnter', pattern: '*',
      \ cmd: 'silent! lcd %:p:h',
      \ group: 'mayhem_misc_setworkdir', replace: v:true,
      \},
      \#{
      \ event: 'BufWinEnter', pattern: '*',
      \ cmd: 'if (get(b:, ''linecount'', 0) < get(g:, ''mayhem_sync_start_max_lines'', 0)) | syn sync fromstart | endif',
      \ group: 'mayhem_misc_synsyncifshort', replace: v:true,
      \},
      \])

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

