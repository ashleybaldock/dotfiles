
" let g:ycm_server_keep_logfiles = 1
" let g:ycm_server_log_level = 'debug'
set encoding=utf-8

nnoremap <leader>o   <C-o>
nnoremap <leader>L   :set list!<CR>
nnoremap <leader>e   :Explore<CR>
nnoremap <leader>es  :Sexplore<CR>
nnoremap <leader>ev  :Vexplore<CR>
nnoremap <leader>t   :set guifont=Menlo:h12<CR>
nnoremap <leader>tt  :set guifont=Menlo:h14<CR>
nnoremap <leader>ttt :set guifont=Menlo:h16<CR>

"CoC
source ~/.vim/coc.vimrc

"vim-qf
nmap <silent> <C-q> <Plug>(qf_qf_switch)
nmap <silent> <C-§> <Plug>(qf_qf_toggle_stay)
nmap <silent> <leader>q <Plug>(qf_qf_toggle_stay)
nmap <silent> <leader>l <Plug>(qf_loc_toggle)
" let g:qf_loclist_window_bottom = 0
let g:qf_mapping_ack_style = 1

" copy full path
:command! CopyPath let @+ = expand("%:p")
" copy just filename
:command! CopyFilename let @+ = expand("%:t")
" copy branch
:command! CopyBranch let @+ = FugitiveHead()

:function! OpenCSSFile()
: if filereadable(expand('%:r') . ".scss")
:   :execute 'vsp' expand('%:r') . ".scss"
: elseif filereadable(expand('%:r') . ".module.scss")
:   :execute 'vsp' expand('%:r') . ".module.scss"
: elseif filereadable(expand('%:r') . ".module.css")
:   :execute 'vsp' expand('%:r') . ".module.css"
: else
:   echo "No matching CSS file found"
: endif
:endfunction
:command! OpenCSS call OpenCSSFile()
nnoremap <C-g><C-s> :OpenCSS<CR>

if has("patch-8.1.0251")
  if !isdirectory($HOME . "/.vim/backup")
    call mkdir($HOME . "/.vim/backup", "p", 0711)
  endif
  set writebackup
  set nobackup
  set backupcopy=auto
  set backupdir^=~/.vim/backup//
end
if !isdirectory($HOME . "/.vim/swap")
  call mkdir($HOME . "/.vim/swap", "p", 0711)
endif
set swapfile
set directory^=~/.vim/swap//
if !isdirectory($HOME . "/.vim/undo")
  call mkdir($HOME . "/.vim/undo", "p", 0711)
endif
set undofile
set undodir^=~/.vim/undo//


if has('gui_running')
  " GUI only
  set guioptions-=rL
  set guioptions+=ck
  set guicursor+=a:blinkon0
  set noantialias
  set guifont=Menlo:h14
else
  " Console only
  set ttyfast

  if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
  endif

  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

autocmd! GUIEnter * set vb t_vb=
set t_Co=256
if !exists("g:syntax_on")
  syntax enable
endif
set re=0
set background=dark
filetype plugin indent on

set ts=2 sts=2 sw=2 et
set enc=utf8
filetype on
set hlsearch
set mouse=a
set backspace=indent,eol,start

set timeout
set timeoutlen=600
set synmaxcol=256

set noea
set nocompatible
set nrformats-=octal
set smarttab
set incsearch
set laststatus=2
set wildmenu
set display+=lastline
set autoread
set showcmd

" Display line movements, except with count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

set updatetime=300

let g:netrw_banner=0
let g:netrw_fastbrowse=0

if !&scrolloff
  set scrolloff=1
endif

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

set formatoptions+=j " Delete comment character when joining commented lines

set breakindent
set showbreak=\\\\\
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
set list

augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  au FileType netrw set nolist
  au FileType gitcommit set nolist
  "au FileType netrw au BufEnter <buffer> set nolist
  "au FileType netrw au BufLeave <buffer> set list
augroup END

set completeopt=longest,menuone,noinsert
set splitbelow

" Searching & Ack (Ag)
" Put word under cursor into search register and highlight
nnoremap <silent> <Leader>* :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
vnoremap <silent> <Leader>* :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy:let @/=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>:set hls<CR>

:function! GcdOrNot()
:  if exists(":Gcd")
:    :Gcd
:  endif
:endfunction
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev Ack Ack!
cnoreabbrev ag call GcdOrNot() <bar> Ack! -Q 
nnoremap <Leader>a :Ack!<Space>
nnoremap • :call GcdOrNot() <bar> Ack! <C-r><C-w>
vnoremap • \* "my:call GcdOrNot() <bar> Ack! <C-r>=fnameescape(@m)

" CtrlP
nnoremap <S-tab>     :CtrlP<CR>
nnoremap <leader>p   :CtrlP<CR>
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Filetype: Python
augroup python_commands
  autocmd!
  au BufEnter *.py set ts=4 sts=4 sw=4 et
  au BufEnter *.pyw set ts=4 sts=4 sw=4 et
augroup END

" Filetype: JavaScript
augroup js_commands
  autocmd!
  au FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
augroup END
let g:jsx_ext_required = 0

" Fugitive
function! S_fugitive()
  if exists('g:loaded_fugitive')
    let l:head = FugitiveHead()
    " return empty(l:head) ? '' : '⎇⃝  ⎇⃣ '.l:head . ' '
    return empty(l:head) ? '' : '⎇ '
  endif
  return ''
endfunction

" vim:set ft=vim et sw=2:

" GitGutter
"let g:gitgutter_sign_priority = 1
" background colours to match the sign column
let g:gitgutter_set_sign_backgrounds = 0

" Run every time ColorScheme changes to ensure overrides
function! MyHighlights() abort
  " Status line
  " StatusLine     xxx term=bold,reverse cterm=bold ctermfg=0 ctermbg=15 gui=bold guifg=Black guibg=#aabbee
  " StatusLineNC   xxx term=reverse ctermfg=0 ctermbg=7 guifg=#444444 guibg=#aaaaaa

  hi StatusLine     cterm=bold ctermfg=0 ctermbg=5 gui=none guifg=White guibg=#232323
  hi StatusLineNC   cterm=italic ctermfg=0 gui=italic guifg=#DDDDDD guibg=#151515
  hi VertSplit      term=reverse cterm=reverse gui=none guifg=#666666 guibg=#151515
  hi syn_error      ctermfg=197 guifg=#FFFFFF guibg=#000000
  hi syn_warn       ctermfg=220 guifg=#FFCC00 guibg=#000000
  hi syn_ok         ctermfg=LightGreen guifg=#55CC00 guibg=#000000
  hi syn_git        ctermfg=92 guifg=#7D27A8 guibg=bg

  hi syn_bold       guibg=#151515

  "highlight Visual     cterm=NONE ctermbg=76  ctermfg=16  gui=NONE guibg=#5fd700 guifg=#000000
  "highlight StatusLine cterm=NONE ctermbg=231 ctermfg=160 gui=NONE guibg=#ffffff guifg=#d70000
  "highlight Normal     cterm=NONE ctermbg=17              gui=NONE guibg=#00005f
  "highlight NonText    cterm=NONE ctermbg=17              gui=NONE guibg=#00005f
  highlight! clear SignColumn
  if has('gui_running')
    highlight link SignColumn Normal
    highlight link CocErrorHighlight SpellBad
    highlight link CocWarningHighlight SpellRare
    highlight link CocInfoHighlight SpellCap
    highlight link CocHintHighlight SpellLocal
  else
    highlight SignColumn ctermbg=0
  endif
  highlight GitGutterAdd    ctermfg=2 ctermbg=0 guifg=#009900 guibg=Black
  highlight GitGutterChange ctermfg=3 ctermbg=0 guifg=#bbbb00 guibg=Black
  highlight GitGutterDelete ctermfg=1 ctermbg=0 guifg=#ff2222 guibg=Black
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END

set statusline=
" errors/warnings in statusline (from CoC)
set statusline+=
" Error indicators
set statusline+=%#syn_error#%{DiagErrors()}%*
set statusline+=%#syn_warn#%{DiagWarnings()}%*
set statusline+=%#syn_ok#%{DiagOk()}%*
" file info
" %t - file name
" %H - help flag
" %W - preview flag
" %M - modified flag
" %R - readonly flag
set statusline+=\ %-t%<\ %H%W%M%R\ 
" git detail if repo
"set statusline+=%#syn_git#%{S_fugitive()}%*
set statusline+=%{S_fugitive()}
" Sep. between left and right
set statusline+=%=
" %(...%) - item group
" %n - buffer number
" %l - line number
" %c - col number
" %V - virtual col number
set statusline+=%(%n\ %l,%c%V\ %P%)\ 
set statusline+=\ 

if has('gui_running')
  colorscheme vividchalk
else
  colorscheme vividchalk
endif
