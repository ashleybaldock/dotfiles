```vim

let s:scriptVar = get(g:, 'name', 'default')
let g:globalVar
let l:localVar

function! s:ScriptScopedStuff(arg1, arg2)
  echom a:arg1
  exec 'echom '..a:arg2
endfunc

function GlobalScopedStuff()
endfunc

command! GlobalScopedCommand1 echo <SID>ScriptScopedStuff()
command! GlobalScopedCommand2 echo GlobalScopedStuff()
```

## Command

```vim
-bang       ": can use ! modifier
-bar        ": can be followed by | + another command
-register   ": first arg can be register name
-buffer     ": buffer local command
-keepscript " use location of invocation for verbose logging

-range[=default]  =% : whole file, =N : N lines, default : current line
-count[=default]  =N : N lines, default: 0
```

<lt> : <lt>bang>
<line1> : start line of command range
<line2> : final
<range> : 0,1,2 items in command range
<count> : count supplied for -range or -count
<bang> : ! or ''
<mods> : commmand-modifiers: [ aboveleft, belowright,
botright, browse, confirm, hide, horizontal,
keepalt, keepjumps, keepmarks, keeppatterns,
leftabove, lockmarks, noautocmd, noswapfile
rightbelow, sandbox, silent, tab, topleft,
unsilent, verbose, vertical ]
<reg> : optional -register
<args> : command arguments
<q-args>: single quoted value for use in an expression
<f-args>: split by whitespace

```vim
    :command -nargs=* Mycmd call Myfunc(<f-args>)

    :Mycmd arg1 arg2   ⮕   :call Myfunc("arg1","arg2")
```

## Mappings

### Using <plug> to export mappings

```vim
" Define
"
" <plug> can be followed by most anything, terminated with <space>
nnoremap <silent> <plug>(PluginCommand) :SomeCommand
nnoremap <silent> <plug>Plugin#Command :SomeCommand

" Use
nmap gc <plug>(PluginCommand)
```
