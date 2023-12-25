
set encoding=utf-8
set nocompatible

let g:coc_node_path = '/opt/homebrew/bin/node'
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
if !isdirectory($HOME . "/.vim/view")
  call mkdir($HOME . "/.vim/view", "p", 0711)
endif
set viewdir^=~/.vim/view//
if !isdirectory($HOME . "/.vim/session")
  call mkdir($HOME . "/.vim/session", "p", 0711)
endif

set helpheight=10

set linespace
set breakindent
set showbreak=\\\\\
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
set list
"set fillchars=vert:|,eob:~,lastline:@,foldclose:+,foldopen:-,foldsep:|,fold:-m,diff:-
colorscheme vividchalk

autocmd! GUIEnter * set vb t_vb=
if has('gui_running')
  set guioptions-=rL
  set guioptions+=ck
  set guicursor+=a:blinkon0
  set noantialias
  set guifont=Menlo:h14

  " set showbreak=\\\\\
  set showbreak=╲

  set listchars=
  " set listchars+=tab:⡢⠤⠤⡦⡢⠤⠤⡦tab
  " set listchars+=tab:⡦⠤⠤⡦⡦⠤⠤⡦tab
  " set listchars+=tab:⢰⠤⠤⡦⢰⠤⠤⡦tab
  " set listchars+=tab:⠕⠒⠒⠗⠕⠒⠒⠗tab
  " set listchars+=tab:⠽⠒⠒⠕⠽⠒⠒⠕tab
  " set listchars+=tab:⠗⠒⠒⠕⠗⠒⠒⠕tab
  " set listchars+=tab:⣲⣒⣒⡢⣲⣒⣒⡢tab
  set listchars+=tab:⣲⣒⡢
  " set listchars+=tab:⣲⠤⠤⡦⣲⠤⠤⡦tab
  set listchars+=multispace:\ ⣀⣀⣀⢀⣀⣀⣀
  set listchars+=lead:⣄
  set listchars+=trail:⢠
  set listchars+=eol:⡟
  "⣏⢽⣎⣝⣟⢟⢛⢹⢻⢼⢫⢣⡯⡱⢷
  " set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
  set fillchars=
  set fillchars+=vert:║
  set fillchars+=eob:⣇
  set fillchars+=lastline:@
  set fillchars+=foldclose:◉
  set fillchars+=foldopen:◯
  set fillchars+=foldsep:▫︎
  set fillchars+=fold:⌶

  colorscheme vividmayhem
else
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

set t_Co=256
set background=dark
if !exists("g:syntax_on")
  syntax enable
endif
set re=0

filetype plugin indent on
set ts=2 sts=2 sw=2 et
set enc=utf8
filetype on

set mouse=a
set backspace=indent,eol,start

set timeout
set timeoutlen=600
set updatetime=300
set synmaxcol=256

set noequalalways
set nrformats-=octal
set smarttab
set laststatus=2
set wildmenu
set display+=lastline
set autoread
set showcmd
set shortmess+=sAIt

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

" Delete comment character when joining commented lines
set formatoptions+=j

set completeopt=longest,menuone,noinsert
set splitbelow

" Searching
set hlsearch
set incsearch
" search up to root when using gf, opening files etc.
set path+=;~

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif


"vim-qf
" let g:qf_loclist_window_bottom = 0
" let g:qf_window_bottom = 0
let g:qf_mapping_ack_style = 1
let g:qf_auto_resize = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_open_quickfix = 0
let g:qf_max_height = 8


" CtrlP
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_root_markers = ['.git', '.root']
let g:ctrlp_match_window = 'top,order:btt,min:1,max:7,results:7'

let g:jsx_ext_required = 0

" vim:set ft=vim et sw=2:

" GitGutter
"let g:gitgutter_sign_priority = 1
" background colours to match the sign column
let g:gitgutter_set_sign_backgrounds = 0



