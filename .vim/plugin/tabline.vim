if exists("g:mayhem_loaded_tabline")
  finish
endif
let g:mayhem_loaded_tabline = 1

"
" au BufWritePost <buffer> :silent UnsetAndReload
"


let s:abbrpaths = [
      \ ":~:s?\\~\/dotfiles\/\.vim\/after/ftplugin?𝙫∕𝙖/𝙛⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/after/plugin?𝙫∕𝙖/𝙥⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/after/syntax?𝙫∕𝙖/𝙨⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/autoload?𝙫∕𝙖𝙪⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/colors?𝙫∕𝙘𝙡⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/ftplugin?𝙫∕𝙛⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/plugin\/?𝙫∕𝙥⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/syntax?𝙫∕𝙨⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/templates?𝙫∕𝙩𝙥𝙡⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/notes?𝙫∕𝙣𝙤𝙩𝙚𝙨⋮?",
      \ ":~:s?\\~\/dotfiles\/\.vim\/?𝙫⋮?",
      \ ":p:s?"..$VIMRUNTIME.."\/syntax?$𝘝𝘙∕𝘴⋮?",
      \ ":p:s?"..$VIMRUNTIME.."\/?$𝘝𝘙⋮?",
      \ ":~:s?\\~\/googledrive\/projects\/?𝒈𝑷⋮?",
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

function! s:FormatBufferName(bufnr = bufnr()) abort
  let bufname = bufname(a:bufnr)
  if empty(bufname)
    return "𝑢𝑛𝑛𝑎𝑚𝑒𝑑"
  else
    return printf("%s %s",
          \ fnamemodify(bufname, s:abbrpaths),
          \ getbufvar(a:bufnr, "&modified")
          \  ? '+'
          \  : getbufvar(a:bufnr, "&modifiable") == 0 
          \    ? '-'
          \    : ''
          \)
  endif
endfunc

function! GuiTabLabel() abort
  let modified = tabpagebuflist(v:lnum)
        \->reduce({acc, bufnr -> acc + getbufvar(bufnr, "&modified", 0)}, 0)

  if tabpagenr() == v:lnum
    return [
          \printf("   %s", modified ? " ̵̩̩" : " "),
          \printf("%d	%-32.32s   %s", modified, s:FormatBufferName(), ChDiag()),
          \printf("%s", "▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆ ")
          \]->join("\n")
  else
    return [
          \printf("   %s", modified ? " ̵̩̩" : " "),
          \printf("%d	%-32.32s", modified, s:FormatBufferName())
          \]->join("\n")
  endif
    " return printf("\n%d․  ⦁%d․-⃤    -⃤ %%<%%=%-26.26s%d+\n▄▄̍̍̍̍̍̍̍▄▆̍̍̍̍̍̍̍▄▄ ̊̊̊̊̊̊▄▄ ̈̈̈̈̈̈̈▄▄▄ˈ▄▄|̩̲▄▄ ̥̥̥̥̥̥▄▄", tabpagenr(), bufname(), modified)
  " return printf("█   _⃤ _̲⃤ _̳⃤    _⃤ _̅⃤ _̿⃤  ‾⃜⃜⃜⃜⃜⃜⃜⃜⃜⃜⃜  _̲̲̲̲̲̲̲̲⃤ 3̩⃤ 3̩̍⃤ 3̍⃤ 3̩̍⃤ 3 ₂̍̍⃤̍⃤̩̩⃤̩̩⃤ ₂̊̊̊̊̊̊⃤̍̍̍⃤ ₂̍⃤̍⃤̍⃤̍⃤̍⃤⃟  3̍̍̍⃤
  
  "  ⁄   𝟭ℴ𝒻𝟯 
  " _⃯   v̲͎  ‡    ‸ ▪︎ ⚬ _̩̩̩̩̩̩__̻̻̻_̩̻̩̻_̩̩_⃓̶̩̩̩  ˌ̵⃒̩ ˌ̵⃒̩̣   ̵⃒̵̵⃒⃒⃒̣̩̣  ˌ̵⃒̩̩  ˌ̵⃒̩     ̵̩̩    ╷̵̵̵⃒⃒      ̤̤̤̤̤̤̤̤̤    ̬̬̬̬̬̬̬   ̩̩̩̩̩    ̣̣̣̣̣̣̣̣ |̶̲‖ˌˌˌ ˇ̑̑ˆ̴̬̬̬̬̬̬̬‸̣̣̣̣̣̣̣̣˖̩̩̣̣̣̣̩̩⸋̣     %%=\n  %d %-40.40s\n▄ ▇▇▇▇▇▇▇▇▇▇▇▇▇▆▆▆▆▆▆▆▆⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺%%=", tabpagenr(), bufname())
          "\printf("%s", ▆▆͘͘͘͘͘͘͘⃤▆▆▆⃤▆̩̩⃤▆▆▆̍̍⃤ 3 3⃤  3̩⃤  3̩̩⃤ 3̩̩⃤ 3⃤  3̍⃤  3̍̍⃤ 3̍̍̍⃤ 3̍̍̍̍⃤ ▆▆▆▆▆▆▆▆▆▆▆ )
endfunction

set guitablabel=%{%GuiTabLabel()%}


function! GuiTabToolTip() abort
  return printf("%s ℴ𝒻 %s\n%d window%s:\n%s%%<",
        \ format#numbers(tabpagenr()->string(), 'sansb'),
        \ format#numbers(tabpagenr('$')->string(), 'sansb'),
        \ tabpagewinnr(v:lnum, '$'),
        \ tabpagewinnr(v:lnum, '$') > 1 ? 's' : '',
        \ tabpagebuflist(tabpagenr())
        \ ->map({i, bufnr -> s:FormatBufferName(bufnr)})
        \ ->join("\n"))
endfunction

set guitabtooltip=%.400{%GuiTabToolTip()%}

