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


let s:match_command = '^Ses\%[sion]'

" '\(c\%[reate]\|l\%[oad]\|l\%[ist]\|p\%[ause]\|r\%[esume]\|d\%[elete]\|i\%[nfo]\)'
let s:match_part_subcommand = '\(' .. 
      \keys(s:subcommands)->mapnew({i, k -> k[0] .. '\%[' .. k[1:-1] .. ']'})
      \->join('\|') .. '\)'

" '\(create\|load\|list\|pause\|resume\|delete\|info\)'
let s:match_full_subcommand = '\(' .. 
      \keys(s:subcommands)->mapnew({i, k -> k})
      \->join('\|') .. '\)'

" e.g. 'create^Minfo^MList^Mload^Mpause^Mresume^Mdelete^M'
let s:subcommand_completion = keys(s:subcommands)->join(" \n")
" echom 's:subcommand_completion ''' .. s:subcommand_completion .. ''' | s:match_subcommand ''' .. s:match_subcommand .. ''''

function! session#name2path(name) abort
  return g:mayhem_dir_session .. '/' .. a:name .. '.session.vim'
endfunc

          " \ '     - updated within',
function! session#list() abort
  return expand('$HOME/.vim/session')
        \ ->readdirex({e -> e.name =~ '.session.vim$'})
        \ ->sort({a, b -> b.time - a.time})
        \ ->map({i, val -> #{
          \ name: fnamemodify(val.name, ":t:r:r"),
          \ updated: format#timeSince(val.time),
          \ time: strftime("[%H:%M:%S %d-%m-%Y]", val.time),
          \ }
          \})
endfunc

function! session#listcomplete() abort
  return map(session#list(), {k, v -> v.name})->join("\n")
endfunc

function! session#complete(ArgLead, CmdLine, CursorPos) abort
  echom 'a:ArgLead: ''' .. a:ArgLead ..
        \ ''', a:CmdLine: ''' .. a:CmdLine ..
        \ ''', a:CursorPos: ''' .. a:CursorPos .. ''''

  if a:CmdLine =~ s:match_command .. '\s\+' .. s:match_full_subcommand .. '\s\+\S\+\s\+$'
    return ''
  elseif a:CmdLine =~ s:match_command .. '\s\+' .. s:match_full_subcommand .. '\s\+\S*$'
    return session#listcomplete()
  elseif a:CmdLine =~ s:match_command .. '\s\+' .. s:match_part_subcommand .. '$'
    return s:subcommand_completion
  elseif a:CmdLine =~ s:match_command .. '\s\+$'
    return s:subcommand_completion
  elseif a:CmdLine =~ s:match_command .. '$'
    return ' '
  else
      return ''
  endif
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

function! session#create(sessionname) abort
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
