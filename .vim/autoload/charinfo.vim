if exists("g:mayhem_autoloaded_charinfo") || &cp
  finish
endif
let g:mayhem_autoloaded_charinfo = 1

"
" See: ../plugin/charinfo.vim
"      ../plugin/highlight.vim
"              ./sfsymbols.vim
"

function! charinfo#get(arg) abort
  let char = empty(a:arg)
        \ ? char2nr(getline('.')[col('.') - 1 : -1])->nr2char()
        \ : char2nr(a:arg)->nr2char()
  let composedchar = empty(a:arg)
        \ ? strpart(getline('.'), col('.') - 1, 1, v:true)
        \ : strpart(a:arg, 0, 1, v:true)

  let output = 'No Char Info'

  " SFSymbols doesn't define any composing characters itself, but    TODO
  " the unicode ones can be used
  let info = GetSfSymbolInfo(char)
  if info.IsValid()
    let output = '⟨' .. composedchar .. '⟩' .. string(info) .. ' (SFSymbol)'
  else
    " TODO implement similar in ./unicode.vim and remove dep.
    if !exists('g:autoloaded_characterize')
      " Characterize's autoload uses redir, which can't be nested
      silent exec 'Characterize'
    endif
    let v:errmsg = ''
    redir => characterise_output
      silent exec 'Characterize ' .. composedchar
    redir END
    if v:errmsg != ''
      echom 'Error running Characterize: ' .. v:errmsg
      let output = #{
            \ err: 'Char Info Err',
            \ in: composedchar,
            \}
    else
      let output = #{
            \ err: v:null,
            \ in: composedchar,
            \ base: #{
            \  char: char,
            \  codepoint: char2nr(char)
            \ },
            \ characterise_output: characterise_output
            \}
    endif
  endif
  return output
endfunc

"
" Formats character info for display in command line
"
" TODO - this should be a method of a CharInfo object
"
function! charinfo#formatForCommand(arg = v:null)
  let chfo = charinfo#get(a:arg)
  return '◤️ '..chfo['base']['char']..'◢️ '..chfo['characterise_output']
       \->trim()
       \->split(', ')
       \->join(' ◢◤ ')..'╱️╱️'
endfunc 
