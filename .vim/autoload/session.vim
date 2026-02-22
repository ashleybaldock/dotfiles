if exists("g:mayhem_autoloaded_session") || &cp
  finish
endif
let g:mayhem_autoloaded_session = 1

"
" Related: ../plugin/session.vim
"

"
" :Session
"          create [<new-session-id>]       (default to auto-generated name)
"          load <existing-session-id>
"          delete [<existing-session-id>]  (default to current session)
"          list                            (all sessions)
"          info 
"          pause
"          resume
"
"
let s:subcommands = #{
      \ create: function('session#create'),
      \   load: function('session#load'),
      \ delete: function('session#delete'),
      \   list: function('session#list'),
      \   info: function('session#info'),
      \  pause: function('session#pause'),
      \ resume: function('session#resume'),
      \}

function! session#dispatch(subcommand, ...) abort
  return get(s:subcommands, a:subcommand)->call(a:000)
endfunc


let s:match_command = '^Ses\%[sion]\s*'

" e.g. '\(c\%[reate]\|l\%[oad]\|l\%[ist]\|p\%[ause]\|r\%[esume]\|d\%[elete]\|i\%[nfo]\)'
let s:match_subcommand = '\(' .. 
      \mapnew(s:subcommands, {k, v -> v[0] .. '\%[' .. v[1:-1] .. ']'})->join('\|') ..
      \ '\)'

let s:match_session = '\W\+'

" e.g. 'create^Minfo^MList^Mload^Mpause^Mresume^Mdelete^M'
let s:subcommand_completion = join(s:subcommands, "\n")

echom s:subcommand_completion
echom s:match_subcommand

function! session#complete(ArgLead, CmdLine, CursorPos) abort
  echom 'a:ArgLead: ''' .. a:ArgLead ..
        \ ''', a:CmdLine: ''' .. a:CmdLine ..
        \ ''', a:CursorPos: ''' .. a:CursorPos .. ''''

  if a:CmdLine =~ s:match_command .. s:match_subcommand .. '\s*' .. s:match_session .. '\s*$'
    return 'a session...'
  elseif a:CmdLine =~ s:match_command .. s:match_subcommand .. '\s*$'
    return  'sessions...'
  elseif a:CmdLine =~ s:match_command .. s:match_subcommand
      return s:subcommand_completion
  else
      return s:subcommand_completion
  endif
endfunc

function! session#name2path(name) abort
  return g:mayhem_dir_session .. '/' .. a:name .. '.session.vim'
endfunc

function! session#list() abort
  return expand('$HOME/.vim/session')
        \ ->readdirex({e -> e.name =~ '.session.vim$'})
        \ ->sort({a, b -> b.time - a.time})
        \ ->map({i, val -> [
          \ fnamemodify(val.name, ":t:r:r"),
          \ '     - updated within',
          \ format#timeSince(val.time),
          \ strftime("[%H:%M:%S %d-%m-%Y]", val.time),
          \ ]})
        \ ->join()
endfunc

function! session#info() abort
  if empty(v:this_session)
    return '𝚗𝚘 𝚜𝚎𝚜𝚜𝚒𝚘𝚗'
  else
    if exists('g:loaded_obsession') && exists('g:this_obsession')
      return 'Obsession: ' .. v:this_session
    else
      return 'Session: ' .. v:this_session
    endif
  endif
endfunc


function! session#title() abort
  if empty(v:this_session)
    return '𝚗𝚘 𝚜𝚎𝚜𝚜𝚒𝚘𝚗'
  else
    return format#session(printf("%.14S", fnamemodify(v:this_session, ':t:r:r')))
  endif
endfunc

function! session#name() abort
  if empty(v:this_session)
    return 'no session'
  else
    return fnamemodify(v:this_session, ':t:r:r')
  endif
endfunc

function! session#create() abort
  exec 'mksession<bang> ~/.vim/session/' .. a:sessionname .. '.session.vim'

  if exists('g:loaded_obsession')
    exec 'Obsession<bang> ~/.vim/session/' .. a:sessionname .. '.session.vim'
  endif
endfunc

function! session#load(sessionname) abort
  exec 'so ~/.vim/session/' .. a:sessionname .. '.session.vim'

  if exists('g:loaded_obsession') && !exists('g:this_obsession')
    Obsession
  endif
endfunc

function! session#pause() abort
  if exists('g:loaded_obsession')
    \ && exists('g:this_session')
    \ && exists('g:this_obsession')
    Obsession
  endif

  DoUserAutoCmd Obsession
endfunc

function! session#resume() abort
  if exists('g:loaded_obsession')
        \ && exists('g:this_session')
        \ && !exists('g:this_obsession')
    exec 'Obsession' g:this_session
  endif
  
  DoUserAutoCmd Obsession
endfunc

function! session#delete(sessionname = get(g:, 'this_session', v:null)) abort
  if exists('g:loaded_obsession')
        \ && exists('g:this_obsession')
        \ && g:this_obsession == '~/.vim/session/' .. a:sessionname .. '.session.vim'
    Obsession
  endif

  exec '!rm ~/.vim/session/' .. a:sessionname .. '.session.vim'
endfunc
