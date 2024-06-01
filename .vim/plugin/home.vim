if exists("g:mayhem_loaded_home")
  finish
endif
let g:mayhem_loaded_home = 1


augroup home
  autocmd VimEnter    * nested call s:OnVimEnter()
  autocmd VimLeavePre * nested call s:OnVimLeavePre()
augroup END

function! s:RenderHeader()
  call append('$', [
        \'   ❙   '..v:version..' '..v:servername..' '..v:progpath..'                   ',
        \'  ⎧╹⎫                                      ╭─────────────────────────────╮    ',
        \'  ⎩╻⎭                                      │                   ⸏         │    ',
        \'   ┃                                       │    ╱╲╱╲ ╱̲╲╲  ╱╱̲ ╱╱̲  ╱╲╱╲    │    ',
        \'  ⎧╹⎫                                      │╴╴╴╱  ╲ ╳  ╲╲╱╱ ╱╱  ╱  ╲ ╲╶╶╶│               ',
        \'  ⎩╻⎭                                      │       ╱ ╲  ╱╱ ╱  ̅ ̅╱         │     ',
        \'   ┃                                       │                             │     ',
        \'  ⎧╹⎫                                      ╰─────────────────────────────╯     ',
        \])                                                                  
endfunc                                                                      
                                                                         
function! s:RenderQuickLinks()
  call append('$', [
        \' ┍┷━┷╾────────────────────────────────────────────────────────────────────────────────┐ ',
        \' │ 𝚀𝚄𝙸𝙲𝙺 𝙰𝙲𝙲𝙴𝚂𝚂                                                                       │ ',
        \' │ 𝟭 : ~/projects/project1/src/commands.typescript.vim                                │ ',
        \' │ 𝟮 : commands.vim                                                                   │ ',
        \' │ 𝟯 : css.vim                                                                        │ ',
        \' │ 𝟰 : highlight.vim                                                                  │ ',
        \' │ 𝟱 : home.vim                                                                       │ ',
        \' │ 𝟲 : openCSS.vim                                                                    │ ',
        \' ┕┯━┯╾────────────────────────────────────────────────────────────────────────────────┘ ',
        \'  ⎩╻⎭   ',
        \'   ┃    ',
        \'  ⎧╹⎫   ',
        \])
endfunc

"\'━⎩━⎭╸S⃣ ╺━╸𝚂𝚎𝚜𝚜𝚒𝚘𝚗𝚜 
function! s:RenderSessionList()
  call append('$', [
        \'  ⎩╻⎭┎───────────────────────────────────────────────────────────────────────────────┐ ',
        \'  ◼︎╋◼︎┫ 𝚂𝚎𝚜𝚜𝚒𝚘𝚗𝚜                                                                      │ ',
        \'  ⎧╹⎫╿ 𝟷 : ~/projects/project1/src/commands.typescript.vim                           │ ',
        \'  ⎩╻⎭│ 𝟸 : commands.vim                                                              │ ',
        \'   ┃ │ 𝟹 : css.vim                                                                   │ ',
        \'  ⎧╹⎫│ 𝟺 : highlight.vim                                                             │ ',
        \'  ⎩╻⎭│ 𝟻 : home.vim                                                                  │ ',
        \'   ┃ │ 𝟼 : openCSS.vim                                                               │ ',
        \'  ⎧╹⎫└───────────────────────────────────────────────────────────────────────────────┘ ',
        \'  ⎩╻⎭   ',
        \'   ┃    ',
        \'  ⎧╹⎫   ',
        \' ┍┷━┷╾────────────────────────────────────────────────────────────────────────────────┐ ',
        \' │ 𝙵𝚒𝚕𝚎𝚜                                                                              │ ',
        \' │ 𝟷 : ~/projects/project1/src/commands.typescript.vim                                │ ',
        \' │ 𝟸 : commands.vim                                                                   │ ',
        \' │ 𝟹 : css.vim                                                                        │ ',
        \' │ 𝟺 : highlight.vim                                                                  │ ',
        \' │ 𝟻 : home.vim                                                                       │ ',
        \' │ 𝟼 : openCSS.vim                                                                    │ ',
        \' ┕┯━┯╾────────────────────────────────────────────────────────────────────────────────┘ ',
        \'  ⎩╻⎭   ',
        \'   ┃    ',
        \'  ⎧╹⎫   ',
        \' ┍┷━┷╾────────────────────────────────────────────────────────────────────────────────┐ ',
        \' │ 𝙿𝚛𝚘𝚓𝚎𝚌𝚝𝚜                                                                           │ ',
        \' │ 𝟷 : ~/projects/project1/src/commands.typescript.vim                                │ ',
        \' │ 𝟸 : commands.vim                                                                   │ ',
        \' │ 𝟹 : css.vim                                                                        │ ',
        \' │ 𝟺 : highlight.vim                                                                  │ ',
        \' │ 𝟻 : home.vim                                                                       │ ',
        \' │ 𝟼 : openCSS.vim                                                                    │ ',
        \' ┕┯━┯╾────────────────────────────────────────────────────────────────────────────────┘ ',
        \])
endfunc

function! s:RenderRecentFilesList()
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

function! s:RenderRecentRootsList()
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

function! s:RenderFooter()
  call append('$', [
        \'   ╿',
        \])
endfunc

function! s:OpenQuick(idx)
  echom a:idx
endfunc

function! s:BindKeys()
  nnoremap <buffer><nowait><silent> i        :enew <bar> startinsert<CR>
  nnoremap <buffer><nowait><silent> <insert> :enew <bar> startinsert<CR>
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

function! s:UpdateRecentlyEdited(file)
endfunc

function! s:OnVimLeavePre() abort
endfunc

function! s:OnVimEnter() abort
  if !argc() && line('$') == 1 && getline('.') == ''
    " Detect session file and offer option to load it   TODO
    if get(g:, 'mayhem_home_autoload_session') && filereadable('Session.vim')
      source Session.vim
    else
      if !get(g:, 'mayhem_disable_home_on_start')
        call s:ShowHome()
      endif
    endif
  endif

  autocmd! home VimEnter
endfunc

function! s:ShowHome()
  " Handle vim -y, vim -M, unsaved buffer
  if (&insertmode || !&modifiable) || (!&hidden && &modified)
    return
  endif

  if line2byte('$') != -1
    noautocmd enew
  endif

  silent! setlocal
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
        \ signcolumn=no
        \ synmaxcol&

  if empty(&statusline)
    setlocal statusline=\ home
  endif
  
  " Edit buffer contents
  silent! setlocal
        \ modifiable
        \ noreadonly

  call map(v:oldfiles, 'fnamemodify(v:val, ":p")')
  au BufNewFile,BufRead,BufFilePre *
        \ call s:UpdateRecentlyEdited(expand('<afile>:p'))

  MessagesSplit

  call s:RenderHeader()

  call s:RenderQuickLinks()

  call s:RenderSessionList()

  call s:RenderRecentRootsList()

  call s:RenderRecentFilesList()

  call s:RenderFooter()

  call s:BindKeys()

  setlocal filetype=mayhemhome

  " Finalise buffer contents
  silent! setlocal
        \ nomodified 
        \ nomodifiable

  au BufUnload <buffer> CloseMessages
endfunction

