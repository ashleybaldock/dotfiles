if exists("g:mayhem_loaded_redir")
  finish
endif
let g:mayhem_loaded_redir = 1



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
" Execute a command and paste the result into
" the current buffer at the cursor position
"
function! ExecAndPut(command) abort
  let @o = ExecAndReturn(a:command)
  silent exec 'norm "ogp'
endfunc

command! -nargs=? ExecAndPut silent call ExecAndPut(<q-args>)

"
" Execute a command and put the result into a register
"
function! ExecToRegister(command, register = '"') abort
  exec 'let @'..a:register..' = ExecAndReturn(a:command)'
endfunc

"
" Execute a command and put the result into a register
"
command! -bar -nargs=1 -register ExecToRegister silent call ExecToRegister(<q-args>, <reg>)

" Execute a command and put the result into unnamed register
"
command! -nargs=? ExecAndYank silent call ExecToRegister(<q-args>, '"')





