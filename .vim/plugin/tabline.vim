if exists("g:mayhem_loaded_tabline")
  finish
endif
let g:mayhem_loaded_tabline = 1

"
" au BufWritePost <buffer> :silent UnsetAndReload
"


set guitabtooltip=%.400{%GuiTabToolTip()%}

let abbrpaths = [
      \ ":s?\\~\/dotfiles\/\.vim\/after/ftplugin?(️v/a/f)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/after/plugin?(️v/a/p)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/after/syntax?(️v/a/s)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/autoload?(️v/au)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/colors?(️v/cl)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/ftplugin?(️v/f)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/plugin?(️v/p)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/syntax?(️v/s)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/templates?(️v/tpl)️?",
      \ ":s?\\~\/dotfiles\/\.vim\/notes?(️v/notes)️?",
      \ ":s?\\~\/dotfiles\/\.vim?(️v)️?",
      \]
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
        \ bufname(bufnr)->empty() ? "%#HlItalic#𝑢𝑛𝑛𝑎𝑚𝑒𝑑%*" : bufname(bufnr)->fnamemodify(":~:s?\\~\/dotfiles\/\.vim?(️v)️?"),
        \ getbufvar(bufnr, "&modified") ? '+' : getbufvar(bufnr, "&modifiable") == 0 ? '-' : ''
        \)})->join("\n"))
endfunction

set guitablabel=%{%GuiTabLabel()%}

function! GuiTabLabel() abort
  let modified = tabpagebuflist(v:lnum)
        \->reduce({acc, bufnr -> acc + getbufvar(bufnr, "&modified", 0)}, 0)

  if tabpagenr() == get(t:, '__tid', -1)
    return [
          \printf(" ̵̩̩  -⃤       ̵̩̩    ╷̵̵̵⃒⃒     %s", modified ? "     ⃯ _⃯   v̲͎  ‡    " : ""),
          \printf("-⃤＋ %d   %-25.25s", modified, bufname()->fnamemodify(":~:s?\\~\/dotfiles\/\.vim?(️v)️?")),
          \printf("%s", "▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆")
          \]->join("\n")
  else
    return printf("\n%d․ ⦁%d․  %%<%%=%-26.26s%d+\n▄▄▄▆̍̍̍̍̍̍̍▄▄ ̊̊̊̊̊̊▄▄ ̈̈̈̈̈̈̈▄▄▄ˈ▄▄|̩̲▄▄ ̥̥̥̥̥̥▄▄", tabpagenr(), bufname(), modified)
  endif
  " return printf("█  ‸ ▪︎ ⚬ _̩̩̩̩̩̩__̻̻̻_̩̻̩̻_̩̩_⃓̶̩̩̩  ˌ̵⃒̩ ˌ̵⃒̩̣   ̵⃒̵̵⃒⃒⃒̣̩̣  ˌ̵⃒̩̩  ˌ̵⃒̩      ̤̤̤̤̤̤̤̤̤    ̬̬̬̬̬̬̬   ̩̩̩̩̩    ̣̣̣̣̣̣̣̣ |̶̲‖ˌˌˌ ˇ̑̑ˆ̴̬̬̬̬̬̬̬‸̣̣̣̣̣̣̣̣˖̩̩̣̣̣̣̩̩⸋̣     %%=\n  %d %-40.40s\n▄ ▇▇▇▇▇▇▇▇▇▇▇▇▇▆▆▆▆▆▆▆▆⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺%%=", tabpagenr(), bufname())
endfunction
