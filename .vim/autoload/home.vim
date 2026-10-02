if exists("g:mayhem_autoloaded_home") || &cp
  finish
endif
let g:mayhem_autoloaded_home = 1

"
" Related:
"   $VIMHOME/plugin/home.vim
"

function! home#renderHeader() abort
  call append('$', [
        \'    ❙   '..v:version..' '..v:servername..' '..v:progpath..'                        ❙   ',
        \'   ⎧╹⎫         􀇀  􀇜 􀇚 􀇠   􀆱􀻞􀆫􀆭􀆳       ╭─────────╲──────╱───────────╮ ⎧╹⎫  ',
        \'   ⎩╻⎭ 􀙬         􀙖    􀋦    􀆲􀻟􀆬􀆮􀆴       │          ╲    ╱╱ ╱_̲_̱       │ ⎩╻⎭  ',
        \'    ┃   􀇢   􀆮􀇂 􀇔􀇖􀇘                       │    ╱╲╱╲ ╱̲╲╲  ╱╱_̲︎╱╱ ╱╲╱╲    │  ┃   ',
        \'   ⎧╹⎫           􀇊 􀇄􀇒                       │╴╴╴╱  ╲ ╳  ╲╲╱╱‾̅︎╱︎╱︎‾̅︎╱︎  ╲ ╲╶╶╶│ ⎧╹⎫  ',
        \'   ⎩╻⎭               􀇞           􀝝􀝝􀝝􀝝     │       ╱ ╲  ╱╱ ╱ ‾̅╱         │ ⎩╻⎭  ',
        \'    ┃                 􀇆 􀇈   􀇥   􀝝􀴾􀴾􀴾    │      ╱    ╱╱               │  ┃   ',
        \'   ⎧╹⎫    􀇧        􀇤􀇦􀇎􀇐􀇌     􀇁          ╰──────────╱─────────────────╯ ⎧╹⎫  ',
        \])                                                                  
endfunc                                                                      

function! home#renderQuickLinks() abort
  call append('$', [
        \' ╭╴┷━┷╶──────────────────────────────────────────────────────────────────────────╴┷━┷╶╮ ',
        \' │  𝚀𝚄𝙸𝙲𝙺 𝙰𝙲𝙲𝙴𝚂𝚂                                                                      │ ',
        \' │ 𝟭 : ~/projects/project1/src/commands.typescript.vim                                │ ',
        \' │ 𝟮 : commands.vim                                                                   │ ',
        \' │ 𝟯 : css.vim                                                                        │ ',
        \' │ 𝟰 : highlight.vim                                                                  │ ',
        \' │ 𝟱 : home.vim                                                                       │ ',
        \' │ 𝟲 : openCSS.vim                                                                    │ ',
        \' ╰╴┯━┯╶──────────────────────────────────────────────────────────────────────────╴┯━┯╶╯ ',
        \'   ⎩╻⎭                                                                            ⎩╻⎭   ',
        \'    ┃                                                                              ┃    ',
        \'   ⎧╹⎫                                                                            ⎧╹⎫   ',
        \])
endfunc

"\'━⎩━⎭╸S⃣ ╺━╸𝚂𝚎𝚜𝚜𝚒𝚘𝚗𝚜 
function! home#renderSessionList() abort
  call append('$', [
        \' ╭╴┷━┷╶───────────────────────────────────────────────────────────────────────────────╮ ',
        \' │  𝚂𝚎𝚜𝚜𝚒𝚘𝚗𝚜                                                                          │ ',
        \' │ 𝟷 : ~/projects/project1/src/commands.typescript.vim                                │ ',
        \' │ 𝟸 : commands.vim                                                                   │ ',
        \' │ 𝟹 : css.vim                                                                        │ ',
        \' │ 𝟺 : highlight.vim                                                                  │ ',
        \' │ 𝟻 : home.vim                                                                       │ ',
        \' │ 𝟼 : openCSS.vim                                                                    │ ',
        \' ╰╴┯━┯╶───────────────────────────────────────────────────────────────────────────────╯ ',
        \'   ⎩╻⎭   ',
        \'    ┃    ',
        \'   ⎧╹⎫   ',
        \' ╭╴┷━┷╶───────────────────────────────────────────────────────────────────────────────╮ ',
        \' │  𝙵𝚒𝚕𝚎𝚜                                                                             │ ',
        \' │ 𝟷 : ~/projects/project1/src/commands.typescript.vim                                │ ',
        \' │ 𝟸 : commands.vim                                                                   │ ',
        \' │ 𝟹 : css.vim                                                                        │ ',
        \' │ 𝟺 : highlight.vim                                                                  │ ',
        \' │ 𝟻 : home.vim                                                                       │ ',
        \' │ 𝟼 : openCSS.vim                                                                    │ ',
        \' ╰╴┯━┯╶───────────────────────────────────────────────────────────────────────────────╯ ',
        \'   ⎩╻⎭   ',
        \'    ┃    ',
        \'   ⎧╹⎫   ',
        \' ╭╴┷━┷╶───────────────────────────────────────────────────────────────────────────────╮ ',
        \' │  𝙿𝚛𝚘𝚓𝚎𝚌𝚝𝚜                                                                          │ ',
        \' │ 𝟷 : ~/projects/project1/src/commands.typescript.vim                                │ ',
        \' │ 𝟸 : commands.vim                                                                   │ ',
        \' │ 𝟹 : css.vim                                                                        │ ',
        \' │ 𝟺 : highlight.vim                                                                  │ ',
        \' │ 𝟻 : home.vim                                                                       │ ',
        \' │ 𝟼 : openCSS.vim                                                                    │ ',
        \' ╰╴┯━┯╶───────────────────────────────────────────────────────────────────────────────╯ ',
        \])
endfunc

function! home#renderRecentFilesList() abort
  call append('$', [
        \' │𝙵│ 𝙵𝚒𝚕𝚎𝚜                                              ',
        \'━⎩━⎭━━━━━━━━━━━━━━━╸                                 ',
        \' ⎩𝟷⎭    ┃                        ◠▬◠ ◠▭◠ ◨▬◧ ◪▬◩    ⎛ ⎞      ',
        \' ⎩╻⎭   ⎧╹⎫    ╭╹╮ ╭❙╮ ╭❙╮        ◡▬◡ ◡▭◡ ●▭● ◫▭◫   ⎛⎝⎞⎠     ',
        \' ⎩𝟸⎭   ⎩╻⎭    ╰╻╯ ⎪ ⎪ ⎪b⎪        ◠▬◠ ◠▭◠ ◎▬● ▜▬▛   ⎝ ⎠     ',
        \' ⎩𝟹⎭    ┃     ╭╹╮ ⎬❙⎨ ⎬❙⎨   ⎬b⎨  ◠▬◡ ◠▭◯ ◯▭◐ ▟▬▙       ',
        \' ⎩𝟺⎭   ⎧╹⎫    │ │ ⎪ ⎪ ⎪a⎪   ⎬a⎨                        ',
        \' ⎩𝟻⎭   ⎩╻⎭  ⎧ ╰❙╯ ╰❙╯ ╰❙╯   ⎬4⎨  ╭▬╮╰▬╮╭▬╯╰▬╯╭ ╭ ╭            ',
        \' ⎩𝟼⎭    ┃  ╭⎩╮╭❙╮ ┃              ┌▬┐└▬┐┌▬┘└▬┘▋ █▕▕ ◡           ',
        \' ⎧╹⎫   ⎧╹⎫ │ ││ │                            ╰ ╰ ╰ ╰            ',
        \'  1︎⃣    ⎪b⎪ ⎩ ⎭╰┃╯                  ◢┸◣  ◢◠◣ ▬▘▝▬         ',
        \'  2⃣    ⎬❙⎨                    ⎞              ▬▖▗▬       ',
        \'  3⃣    ⎪a⎪        ⎪ ⎪         ⎛ ▐                       ',
        \'  4⃣    ╰╻╯       ⎧╰⎫╯       ⎝ ⎠       ▞▞▞    ▚▗▘▞▚ ▞▖▗▚          ',
        \'  5⃣              ⎩╭⎭╮                  ▞▞▞   ▞▗▘ ▚▞ ▚▘▝▞     ',
        \'  6︎⃣   ⎩╻⎭  ⎪ ⎪    ⎪ ⎪       ⎛ ⎞                 ▞▚ ▞▖▗▚▐▗▚▗▚▗▚▗▚▗▚▗▚▗▚▗▚      ',
        \'  ╻    ┃  ⎧╰⎫╯   ⎧╰⎫╯       ⎝ ⎠                 ▚▞  ▚▘▝▞ ▝▞▝▞▝▞▝▞▝▞▝▞▝▞▝▞        ',
        \'  ╻   ⎧╹⎫ ⎩╭⎭╮   ⎩╭⎭╮       ⎝ ⎠          ▐      ▚▞                   ',
        \'  ╻               ⎪ ⎪       ⎝ ⎠      ▞▖▗▚▐      ▚▞  ▚▘▗▚ ▞▖▝▞▞▖▐▚▚▚▚▌ ',
        \'  ╻   ⎬❙⎨        ⎧╰⎫╯       ⎝ ⎠       ▚▜▝▞      ▚▞  ▚▘▝▞ ▚▘▗▚▚▘▐▚▚▚▚▌ ▔▐▖▚▝▖▌',
        \'  ╻   ⎪ ⎪        ⎩╭⎭╮       ⎬❙⎨        ▐        ▚▞  ▚▘▗▚ ▞▖▝▞▞▖▐▐▐▐▐▐  ▐▝▖▚▝▌',
        \'  ╻                         ⎪ ⎪                 ▚▞  ▚▘▝▞ ▚▘▗▚▚▘▐▞▞▞▞▌ ▁▐▚▝▖▚▌',
        \'  ╻                         ⎬❙⎨                 ▚▞  ▚▘▗▚ ▞▖▝▞▞▖▐▝▖▚▝▌ ▔▐▖▚▝▖▌',
        \'  ╻                         ⎪ ⎪                 ▚▞  ▚▘▗▚ ▞▖▗▚▚▘▐▚▝▖▚▌  ▐▝▖▚▝▌',
        \'  ╻                         ⎝ ⎠                 ▚▞  ▚▘▗▚ ▞▖▝▞▞▖▐▖▚▝▖▌ ▁▐▚▝▖▚▌',
        \'  ╻                         ⎝ ⎠                 ▚▞  ▚▘▗▚ ▞▖▗▚▚▘▐▝▖▚▝▌ ',
        \'  ╻                         ⎝ ⎠                 ▚▞  ▚▘▗▚ ▞▖▝▞▞▖▐▚▝▖▚▌ ',
        \'  ╻                         ⎝ ⎠                 ▚▞  ▚▘▗▚ ▞▖▗▚▚▘▐▖▚▝▖▌ ',
        \'  ╻                         ⎝ ⎠                 ▚▞  ▚▘▗▚ ▞▖▝▞▞▖▐▝▖▚▝▌ ',
        \'  ╻                         ⎝ ⎠                 ▚▞  ▚▘▗▚ ▞▖▗▚▚▘▐▚▝▖▚▌ ',
        \'  ╻                         ⎝ ⎠                 ▚▞  ▚▘▗▚ ▞▖    ▐▝▖▚▝▌ ',
        \])
endfunc

function! home#renderRecentRootsList()
  call append('$', [
        \' │ │𝙿𝚁𝙾𝙹𝙴𝙲𝚃                               ',
        \' │𝚁│𝙾𝙾𝚃                                   ',
        \'𝚙│𝚁│𝚘𝚓𝚎𝚌𝚝𝚜                                ',
        \' │𝚁│𝚘𝚘𝚝                                   ',
        \' │ │𝙿𝚛𝚘𝚓𝚎𝚌𝚝                               ',
        \' │𝚁│𝚘𝚘𝚝                                   ',
        \'   ┣╸R⃣ ╺━╸Roots                          ',
        \'   ╹   𝚛⃝  𝚁  𝚚⃝  𝚀                         ',
        \'   1︎⃣                             ',
        \'   2⃣                             ',
        \'   3⃣                             ',
        \'   4⃣                             ',
        \'   5⃣                             ',
        \'   6︎⃣                             ',
        \])
endfunc

function! home#renderFooter() abort
  call append('$', [
        \'   ╿',
        \])
endfunc

function! home#openQuick(idx) abort
  echom a:idx
endfunc

function! home#bindKeys() abort
  nnoremap <buffer><nowait><silent> i        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> I        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> <insert> :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> a        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> A        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> o        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> O        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> r        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> R        :enew <bar> startinsert<CR>

  " <D-v> (paste) is handled via a binding to <Plug>(mayhem_paste)
  " see: ../gvimrc  ../plugin/#mayhem.vim ../autoload/mayhem.vim
  nnoremap <buffer><nowait><silent> p        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> P        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> q1 :call <SID>OpenQuick(1)<CR>
  nnoremap <buffer><nowait><silent> q2 :call <SID>OpenQuick(2)<CR>
  nnoremap <buffer><nowait><silent> q3 :call <SID>OpenQuick(3)<CR>
  nnoremap <buffer><nowait><silent> q4 :call <SID>OpenQuick(4)<CR>
  nnoremap <buffer><nowait><silent> q5 :call <SID>OpenQuick(5)<CR>
  nnoremap <buffer><nowait><silent> q6 :call <SID>OpenQuick(6)<CR>

  nnoremap <buffer><nowait><silent> s1 :call <SID>OpenSession(1)<CR>
  nnoremap <buffer><nowait><silent> s2 :call <SID>OpenSession(2)<CR>
  nnoremap <buffer><nowait><silent> s3 :call <SID>OpenSession(3)<CR>
  nnoremap <buffer><nowait><silent> s4 :call <SID>OpenSession(4)<CR>
  nnoremap <buffer><nowait><silent> s5 :call <SID>OpenSession(5)<CR>
  nnoremap <buffer><nowait><silent> s6 :call <SID>OpenSession(6)<CR>

  nnoremap <buffer><nowait><silent> s1 :call <SID>OpenProject(1)<CR>
  nnoremap <buffer><nowait><silent> s2 :call <SID>OpenProject(2)<CR>
  nnoremap <buffer><nowait><silent> s3 :call <SID>OpenProject(3)<CR>
  nnoremap <buffer><nowait><silent> s4 :call <SID>OpenProject(4)<CR>
  nnoremap <buffer><nowait><silent> s5 :call <SID>OpenProject(5)<CR>
  nnoremap <buffer><nowait><silent> s6 :call <SID>OpenProject(6)<CR>

  nnoremap <buffer><nowait><silent> s1 :call <SID>OpenFile(1)<CR>
  nnoremap <buffer><nowait><silent> s2 :call <SID>OpenFile(2)<CR>
  nnoremap <buffer><nowait><silent> s3 :call <SID>OpenFile(3)<CR>
  nnoremap <buffer><nowait><silent> s4 :call <SID>OpenFile(4)<CR>
  nnoremap <buffer><nowait><silent> s5 :call <SID>OpenFile(5)<CR>
  nnoremap <buffer><nowait><silent> s6 :call <SID>OpenFile(6)<CR>
endfunc

function! home#updateRecentlyEdited(file) abort
endfunc

function! home#onVimLeavePre() abort
endfunc

function! home#onVimEnter() abort
  if !argc() && line('$') == 1 && getline('.') == ''
    " Detect session file and offer option to load it   TODO
    if (get(g:, 'mayhem_home_autoload_session', 0) == 1) && filereadable('Session.vim')
      source Session.vim
    else
      if !get(g:, 'mayhem_disable_home_on_start')
        call home#show()
      endif
    endif
  endif

  call autocmd_delete([#{ event: '*', group: 'mayhem_home_enter'}])
endfunc

function! home#close() abort
  call get(s:, 'messages_bufnr', -1)
        \->win_findbuf()
        \->foreach('"echo :" .. win_id2win(v:val) .. "quit"')

  DoUserAutocmd MayhemHomeClosed
endfunc

function! home#show() abort
  " Handle vim -y, vim -M, unsaved buffer
  if (&insertmode || !&modifiable) || (!&hidden && &modified)
    return
  endif

  if line2byte('$') != -1
    noautocmd enew
  endif

  let b:mayhem_home = 1

  silent! setlocal
        \ buftype=nofile
        \ bufhidden=wipe
        \ colorcolumn=
        \ foldcolumn=0
        \ matchpairs=
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ nonumber
        \ norelativenumber
        \ nospell
        \ noswapfile
        \ nowrap
        \ signcolumn=yes
        \ synmaxcol&

  if empty(&statusline)
    setlocal statusline=\ home
  endif
  
  " Edit buffer contents
  silent! setlocal modifiable noreadonly

  call map(v:oldfiles, 'fnamemodify(v:val, ":p")')

  call home#renderHeader()

  call home#renderQuickLinks()

  call home#renderSessionList()

  call home#renderRecentRootsList()

  call home#renderRecentFilesList()

  call home#renderFooter()

  call home#bindKeys()

  setlocal filetype=mayhemhome

  " Finalise buffer contents
  silent! setlocal nomodified nomodifiable

  let s:messages_bufnr = messages#split()

  call autocmd_add([
        \#{
        \ event: ['BufNewFile','BufRead','BufFilePre'], replace: v:true,
        \ cmd: 'call home#updateRecentlyEdited(expand("<afile>:p"))',
        \ group: 'mayhem_home_recent_edit',
        \},
        \#{
        \ event: ['BufWinLeave','BufUnload'], replace: v:true,
        \ cmd: 'call home#close()', bufnr: bufnr(),
        \ group: 'mayhem_home_close',
        \},
        \])
endfunc

