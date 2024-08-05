if exists("g:mayhem_loaded_incversion")
  finish
endif
let g:mayhem_loaded_incversion = 1


" Increment UserScript Version On Save:
"
" "// @version 0.3.22" -> "// @version 0.3.23"
" '^\/\/ @version\s\+\(\d\)\+\.\(\d\)\+\.\(\d\)\+\s*$'
" '^\/\/ @version\s\+\d\+\.\d\+\.\zs\d\+\ze\s*$'
"
function! s:StoreAndIncrement(major, minor, patch)
  let b:mayhem_fileversion_last = { 'major': a:major, 'minor': a:minor, 'patch': a:patch }
  let b:mayhem_fileversion = { 'major': a:major, 'minor': a:minor, 'patch': a:patch + 1}
  return b:mayhem_fileversion['patch']
endfunc
function! s:VersionIncrementMessage()
  return '@version: '
        \ .. b:mayhem_fileversion_last['major']
        \ .. '.' .. b:mayhem_fileversion_last['minor']
        \ .. '.' .. b:mayhem_fileversion_last['patch']
        \ .. ' --> '
        \ .. b:mayhem_fileversion['major']
        \ .. '.' .. b:mayhem_fileversion['minor']
        \ .. '.' .. b:mayhem_fileversion['patch']
endfunc

function! s:IncrementUserScriptVersion()
  norm m`
  exec '1,20s/^\/\/ @version\s\+\(\d\+\)\.\(\d\+\)\.\zs\(\d\+\)\ze\s*$/\=s:StoreAndIncrement(submatch(1), submatch(2), submatch(3))'
  norm g``
endfunc

augroup IncrementUserScriptVersion
  autocmd!
  autocmd BufWritePre,FileWritePre *.user.js call s:IncrementUserScriptVersion()
  autocmd BufWritePost *.user.js redraw | echomsg '"'
        \ .. expand('<afile>')
        \ .. '" ' .. &lines .. 'L, '
        \ .. wordcount()['bytes'] .. 'B written'
        \ .. ', ' .. s:VersionIncrementMessage()
augroup END


