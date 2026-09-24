if exists("g:mayhem_autoloaded_charinfo") || &cp
  finish
endif
let g:mayhem_autoloaded_charinfo = 1

"
" Related:
"      ../plugin/charinfo.vim
"      ../plugin/highlight.vim
"              ./sfsymbols.vim
"


function! charinfo#name(char) abort
  " SFSymbols doesn't define any composing characters itself, but    TODO
  " the unicode ones can be used
  let info = GetSfSymbolInfo(a:char)
  if info.IsValid()
    return info.GetId() .. ' (SFSymbols)'
  else
    " TODO implement similar in ./unicode.vim and remove dep.
    if !exists('g:autoloaded_characterize')
      " Characterize's autoload uses redir, which can't be nested
      silent exec 'Characterize'
    endif

    let characterise_output = execute('Characterize ' .. a:char)

    return matchstr(characterise_output, ', U+\x\+ \zs[^,]*')
          \->format#lowercase()
          \->format#spacedtitlecase()
  endif
endfunc

function! charinfo#get(str = char#fromCursor()) abort
  let first = char#first(a:str)
  return char#split(first)
        \ ->get(0, [])
        \ ->map({i, v -> (#{
        \  composed: first,
        \  char: v,
        \  index: i,
        \  code: char#code(v),
        \  name: charinfo#name(v),
        \  })
        \ }
        \)
endfunc

"
" Formats character info for display in command line
"
" Returns a string to exec
"
function! charinfo#formatForCommand(str = char#fromCursor()) abort
  let chfo = charinfo#get(a:str)
  if len(chfo) == 0
    return ' ╱ nul ╱ '
  elseif len(chfo) == 1
    return ' ╱ ' .. chfo[0]['char'] .. ' / ' .. chfo[0]['code'] .. ' / ' .. chfo[0]['name'] .. ' ╱ '
  else
    return ['',
          \ chfo[0]['composed'],
          \ map(chfo, {i, v -> [
          \  char#display(v['char']),
          \  v['code'],
          \  v['name']
          \ ]->join(' / ')})->join(' ╱ '),
          \ '',
          \ ]->join(' ╱ ')
  endif
endfunc 

let s:sep = echo#memo('CISep', ' ╱ ')
let s:none = echo#with('None')
let s:char = echo#with('None')
let s:code = echo#with('Special')
let s:name = echo#with('CommentSubtle')

"
" Fancier character info for display in command line
"
" Returns a string to exec
"
function! charinfo#formatForCommandWithColor(str = char#fromCursor()) abort

  let chfo = charinfo#get(a:str)
  if len(chfo) == 0
    return [ s:sep(), s:sep(), 'nul', s:sep() ]->join(' | ')
  elseif len(chfo) == 1
    return [
          \ s:sep(),
          \ s:char(char#display(chfo[0]['char'])),
          \ s:sep(),
          \ s:code(chfo[0]['code']),
          \ s:none(' '),
          \ s:name(chfo[0]['name']),
          \ s:sep(),
          \]->join(' | ')
  else
    return [
          \ s:sep(),
          \ s:char(char#display(chfo[0]['composed'])),
          \ map(chfo,
          \  {i, v -> [
          \   s:sep(),
          \   s:char(char#display(v['char'])),
          \   s:code(v['code']),
          \   s:none(' '),
          \   s:name(v['name']),
          \   ]
          \ }),
          \ s:sep(),
          \]->flatten()->join(' | ')
  endif
endfunc 
