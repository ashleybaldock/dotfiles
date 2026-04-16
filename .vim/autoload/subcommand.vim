if exists("g:mayhem_autoloaded_subcommand") || &cp
  finish
endif
let g:mayhem_autoloaded_subcommand = 1

"
" See: ../plugin/subcommand.vim
"

function! subcommand#configure(name, subcommands, ) abort
  let match_command = name[0] .. '\%[' k[1:-1] .. ']'
  let match_partial_subcommand = '\(' .. 
      \keys(a:subcommands)
      \->mapnew({i, k -> k[0] .. '\%[' .. k[1:-1] .. ']'})
      \->join('\|') .. '\)'
  let match_full_subcommand = '\(' .. 
      \keys(a:subcommands)
      \->mapnew({i, k -> k})
      \->join('\|') .. '\)'
  let subcommand_completion = keys(a:subcommands)->join(" \n")


  function dispatch(subcommand, ...) abort
    return get(s:subcommands, a:subcommand)->call(a:000)
  endfunc
endfunction



call subcommand#configure('Session', #{
      \ create: #{ do: function('session#create'), args: [subcommand#arg] },
      \ load: #{ do: function('session#load'), args: [
      \  function('session#listcomplete')
      \ ] },
      \ delete: #{ do: function('session#delete', args: [
      \  function('session#listcomplete')
      \ ] },
      \   list: function('session#list'),
      \   info: function('session#info'),
      \  pause: function('session#pause'),
      \ resume: function('session#resume'),
      \})

