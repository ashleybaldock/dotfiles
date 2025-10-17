if exists("g:mayhem_loaded_tabline")
  finish
endif
let g:mayhem_loaded_tabline = 1

"
" au BufWritePost <buffer> :silent UnsetAndReload
"


set guitabtooltip=%.400{%GuiTabToolTip()%}

let s:abbrpaths = [
      \ ":s?\\~\/dotfiles\/\.vim\/after/ftplugin?𝙫∕𝙖/𝙛⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/after/plugin?𝙫∕𝙖/𝙥⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/after/syntax?𝙫∕𝙖/𝙨⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/autoload?𝙫∕𝙖𝙪⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/colors?𝙫∕𝙘𝙡⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/ftplugin?𝙫∕𝙛⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/plugin\/?𝙫∕𝙥⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/syntax?𝙫∕𝙨⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/templates?𝙫∕𝙩𝙥𝙡⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/notes?𝙫∕𝙣𝙤𝙩𝙚𝙨⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/?𝙫⋮?",
      \ ":s?\\~\/googledrive\/projects\/?𝒈𝑷⋮?",
      \]->join('')
" 𝙪𝙣𝙣𝙖𝙢𝙚𝙙
" 𝘶𝘯𝘯𝘢𝘮𝘦𝘥
" 𝓊𝓃𝓃𝒶𝓂ℯ𝒹
" 𝑢𝑛𝑛𝑎𝑚𝑒𝑑
" 𝖚𝖓𝖓𝖆𝖒𝖊𝖉
" 𝘶𝘯𝘯𝘢𝘮𝘦𝘥
" 𝚞𝚗𝚗𝚊𝚖𝚎𝚍
"
"
function! GuiTabToolTip() abort
  return printf("tab %d/%d\n%s%%<", tabpagenr(), tabpagenr('$'),
        \ tabpagenr()
        \->tabpagebuflist()
        \->map({i, bufnr -> printf("%s %s",
        \ bufname(bufnr)->empty() ? "%#HlItalic#𝑢𝑛𝑛𝑎𝑚𝑒𝑑%*" : bufname(bufnr)
        \ ->fnamemodify(":~"..s:abbrpaths),
        \ getbufvar(bufnr, "&modified") ? '+' : getbufvar(bufnr, "&modifiable") == 0 ? '-' : ''
        \)})->join("\n"))
endfunction

set guitablabel=%{%GuiTabLabel()%}

function! GuiTabLabel() abort
  let modified = tabpagebuflist(v:lnum)
        \->reduce({acc, bufnr -> acc + getbufvar(bufnr, "&modified", 0)}, 0)

  if tabpagenr() == get(t:, '__tid', -1)
    return [
          \printf("   %s", modified ? " ̵̩̩" : " "),
          \printf("%d	%-32.32s", modified, bufname()
          \ ->fnamemodify(":~"..s:abbrpaths)),
          \printf("%s", "▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆ ")
          \]->join("\n")
  else
    return printf("\n%d․  ⦁%d․-⃤    -⃤ %%<%%=%-26.26s%d+\n▄▄̍̍̍̍̍̍̍▄▆̍̍̍̍̍̍̍▄▄ ̊̊̊̊̊̊▄▄ ̈̈̈̈̈̈̈▄▄▄ˈ▄▄|̩̲▄▄ ̥̥̥̥̥̥▄▄", tabpagenr(), bufname(), modified)
  endif
  " return printf("█   _⃤ _̲⃤ _̳⃤    _⃤ _̅⃤ _̿⃤  ‾⃜⃜⃜⃜⃜⃜⃜⃜⃜⃜⃜  _̲̲̲̲̲̲̲̲⃤ 3̩⃤ 3̩̍⃤ 3̍⃤ 3̩̍⃤ 3 ₂̍̍⃤̍⃤̩̩⃤̩̩⃤ ₂̊̊̊̊̊̊⃤̍̍̍⃤ ₂̍⃤̍⃤̍⃤̍⃤̍⃤⃟  3̍̍̍⃤
  
  " _⃯   v̲͎  ‡    ‸ ▪︎ ⚬ _̩̩̩̩̩̩__̻̻̻_̩̻̩̻_̩̩_⃓̶̩̩̩  ˌ̵⃒̩ ˌ̵⃒̩̣   ̵⃒̵̵⃒⃒⃒̣̩̣  ˌ̵⃒̩̩  ˌ̵⃒̩     ̵̩̩    ╷̵̵̵⃒⃒      ̤̤̤̤̤̤̤̤̤    ̬̬̬̬̬̬̬   ̩̩̩̩̩    ̣̣̣̣̣̣̣̣ |̶̲‖ˌˌˌ ˇ̑̑ˆ̴̬̬̬̬̬̬̬‸̣̣̣̣̣̣̣̣˖̩̩̣̣̣̣̩̩⸋̣     %%=\n  %d %-40.40s\n▄ ▇▇▇▇▇▇▇▇▇▇▇▇▇▆▆▆▆▆▆▆▆⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺%%=", tabpagenr(), bufname())
          "\printf("%s", ▆▆͘͘͘͘͘͘͘⃤▆▆▆⃤▆̩̩⃤▆▆▆̍̍⃤ 3 3⃤  3̩⃤  3̩̩⃤ 3̩̩⃤ 3⃤  3̍⃤  3̍̍⃤ 3̍̍̍⃤ 3̍̍̍̍⃤ ▆▆▆▆▆▆▆▆▆▆▆ )
endfunction
