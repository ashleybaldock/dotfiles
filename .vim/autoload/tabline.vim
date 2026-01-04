if exists("g:mayhem_autoloaded_tabline") || &cp
  finish
endif
let g:mayhem_autoloaded_tabline = 1

"
" See: ../plugin/tabline.vim
"

let s:abbrpaths = [
      \ ":p:s?"..$VIMRUNTIME.."\/syntax?$𝘝𝘙∕𝘴⋮?",
      \ ":p:s?"..$VIMRUNTIME.."\/?$𝘝𝘙⋮?",
      \ ":~",
      \ ":s?\\~\/dotfiles\/\.vim\/after\/ftplugin?𝙫∕𝙖/𝙛⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/after\/plugin?𝙫∕𝙖/𝙥⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/after\/syntax?𝙫∕𝙖/𝙨⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/autoload?𝙫∕𝙖𝙪⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/colors?𝙫∕𝙘𝙡⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/ftplugin?𝙫∕𝙛⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/plugin?𝙫∕𝙥⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/syntax?𝙫∕𝙨⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/templates?𝙫∕𝙩𝙥𝙡⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/notes?𝙫∕𝙣𝙤𝙩𝙚𝙨⋮?",
      \ ":s?\\~\/dotfiles\/\.vim?𝙫⋮?",
      \ ":s?\\~\/projects\/noita-wand-simulator\/?𝒲⋮?",
      \ ":s?\\~\/projects?𝑷⋮?",
      \]->join('')

function! tabline#modstatus(bufnr = bufnr()) abort
  return getbufvar(a:bufnr, "&modified")
        \  ? getbufvar(a:bufnr, "&modifiable")
        \    : '+'
        \    ? '-'
        \  : ''
endfunction

function! tabline#bufname(bufnr = bufnr()) abort
  let bufname = bufname(a:bufnr)
  if empty(bufname)
    " 𝙪𝙣𝙣𝙖𝙢𝙚𝙙 𝘶𝘯𝘯𝘢𝘮𝘦𝘥 𝓊𝓃𝓃𝒶𝓂ℯ𝒹 𝑢𝑛𝑛𝑎𝑚𝑒𝑑 𝖚𝖓𝖓𝖆𝖒𝖊𝖉 𝘶𝘯𝘯𝘢𝘮𝘦𝘥 𝚞𝚗𝚗𝚊𝚖𝚎𝚍
    let bufname = "𝑢𝑛𝑛𝑎𝑚𝑒𝑑"
  else
    let bufname = fnamemodify(bufname, s:abbrpaths)
  endif
  return printf("%s %s", bufname, tabline#modstatus(a:bufnr))
endfunction

function! tabline#updateCachedBufferName(bufnr = bufnr()) abort
  call setbufvar(a:bufnr, 'mayhem_tl_cached_filename',
        \ tabline#bufname(a:bufnr))
endfunction

function! tabline#updateDiagnostics() abort
  for i in range(tabpagenr('$'))
    let warningCount = 0
    let errorCount = 0

    if exists('g:did_coc_loaded')
      for bufnr in tabpagebuflist(i)
        let diaginfo = getbufvar(bufnr, 'coc_diagnostic_info', {})
        let warningCount += get(diaginfo, 'warning', 0)
        let errorCount += get(diaginfo, 'error', 0)
      endfor
    endif

    call settabvar(i, 'mayhem_tl_cached_diagnostics', #{
          \ error: errorCount,
          \ warning: warningCount,
          \})
  endfor
endfunction

