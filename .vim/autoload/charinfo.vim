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

    let v:errmsg = ''
    redir => characterise_output
      silent exec 'Characterize ' .. a:char
    redir END

    if v:errmsg != ''
      echom 'Error running Characterize: ' .. v:errmsg
      return 'Unknown (Err)'
    else
      return format#spacedtitlecase(format#lowercase(matchstr(characterise_output, ', U+\x\+ \zs[^,]*')))
      " return matchstr(characterise_output, ', \zsU+[^,]*')
    endif
  endif
endfunc

function! charinfo#get(str = char#fromCursor()) abort
  let composedchar = char#first(a:str)
  " let basechar = empty(a:arg)
  "       \ ? char2nr(getline('.')[col('.') - 1 : -1])->nr2char()
  "       \ : char2nr(a:arg)->nr2char()
  " let composedchar = empty(a:arg)
  "       \ ? strpart(getline('.'), col('.') - 1, 1, v:true)
  "       \ : strpart(a:arg, 0, 1, v:true)

  return map(char#split(composedchar), {i, v -> #{
        \  composed: composedchar,
        \  char: v,
        \  index: i,
        \  code: char#code(v),
        \  name: charinfo#name(v),
        \  }})

endfunc

"
" Formats character info for display in command line
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

function! charinfo#formatForCommandWithColor(str = char#fromCursor()) abort
  let chfo = charinfo#get(a:str)
  if len(chfo) == 0
    return 'echoh CISep | echon '' ╱ '' | echoh None | echon ''nul'' | echoh CISep | echon '' ╱ '' | echoh None | echon '''''
  elseif len(chfo) == 1
    return [
          \ 'echoh CISep | echon '' ╱ ''',
          \ 'echoh None | echon ''' ..  char#display(chfo[0]['char']) .. '''',
          \ 'echoh CISep | echon '' ╱ ''',
          \ 'echoh Special | echon ''' .. chfo[0]['code'] .. '''',
          \ 'echoh None | echon '' ''',
          \ 'echoh CommentSubtle | echon ''' .. chfo[0]['name'] .. '''',
          \ 'echoh CISep | echon '' ╱ ''',
          \ 'echoh None | echon ''''',
          \]->join(' | ')
  else
    return ['echon ''',
          \ chfo[0]['composed'],
          \ map(chfo, {i, v -> [
          \  char#display(v['char']),
          \  ''' | echoh Special | echon ''' .. v['code'] .. ''' | echoh None | echon ''',
          \  ''' | echoh CommentSubtle | echon ''' .. v['name'] .. ''' | echoh None | echon ''',
          \ ]->join(' ')})
          \  ->join(''' | echoh CISep | echon '' ╱ '' | echoh None | echon '''),
          \ ''''
          \ ]->join(''' | echoh CISep | echon '' ╱ '' | echoh None | echon ''')
  endif
endfunc 
