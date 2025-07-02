if exists("g:mayhem_loaded_redir")
  finish
endif
let g:mayhem_loaded_redir = 1



"
" Execute a command and return the output
"
function! ExecAndReturn(command) abort
	let v:errmsg = ''
  let output = ''
  redir => output
    silent exec a:command
  redir END
	if v:errmsg != ''
    echom v:errmsg
  else
    return trim(output)
  endif
endfunc

"
" Execute a command and return output as a list
" Splits output into lines by default
"
function! ExecAndReturnList(command, splitpattern = '\n') abort
  return ExecAndReturn(a:command)->split(a:splitpattern)
endfunc

"
" Execute a command and display result in quickfix
"
function! ExecAndList(command) abort
    call setqflist([], ' ', #{
          \ nr: '$',
          \ title : '╱ ExecAndList ╱ :' .. a:command .. ' ╱',
          \ context : a:command,
          \ lines: ExecAndReturnList(a:command, '\n')})
    copen
endfunc

command! -complete=command -nargs=1 ExecAndList silent call ExecAndList(<q-args>)

"
" Execute a command and paste the result into
" the current buffer at the cursor position
"
function! ExecAndPut(command) abort
  exec "normal! a" .. ExecAndReturn(a:command) .. "\<Esc>"
endfunc

command! -complete=command -nargs=1 
      \ ExecAndPut silent call ExecAndPut(<q-args>)

"
" Execute a command and put the result into a split
"
function! ExecAndSplit(command, vertical = v:true) abort
  let result = ExecAndReturn(a:command)
  :19vnew
  setlocal modifiable
  call setline(1, '> ' .. a:command)
  call setline(2, '┈ ┈ ┈ ┈ ┈ ┈ ┈ ┈ ┈ ┈ ┈ ┈')
  call append(line('$'), result)
  set nomodified
endfunc

"
" Execute a command and put the result into a register
"
function! ExecToRegister(command, register = '"') abort
  exec 'let @'..a:register..' = ExecAndReturn(a:command)'
endfunc

"
" Execute a command and put the result into a register
"
command! -complete=command -nargs=1 -register 
      \ ExecToRegister silent call ExecToRegister(<q-args>, <reg>)

" Execute a command and put the result into unnamed register
"
command! -complete=command -nargs=1 
      \ ExecAndYank silent call ExecToRegister(<q-args>, '"')

command! -complete=command -nargs=1 
      \ ExecAndCopy silent call ExecToRegister(<q-args>, '+')

command! -complete=command -nargs=1
      \ ExecAndSplit silent call ExecAndSplit(<q-args>)




