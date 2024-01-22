set encoding=utf-8
scriptencoding utf-8
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

set t_Co=256
set background=dark
set linespace=0
set breakindent
" set breakat= 	!@*-+;:,./?

" fallback for ./plugins/chars.vim
set showbreak=\\
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
let g:hide_list_in_visual = 1
let g:default_list_style = 'minimal'

colorscheme vividmayhem
if !exists("g:syntax_on")
  syntax enable
endif

" Visual bell + error flash off
autocmd! GUIEnter * set vb t_vb=

if has('gui_running')
  set guioptions-=rL
  set guioptions+=ck
  set guicursor+=a:blinkon0
  set antialias
  set guifont=Menlo:h14
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

set re=0

filetype plugin indent on
set ts=2 sts=2 sw=2 et

set mouse=a
set backspace=indent,eol,start

set timeout
set timeoutlen=600
set updatetime=300
set synmaxcol=256

set foldnestmax=4
set foldminlines=3

set cmdheight=1
set equalalways
set eadirection=hor
set splitbelow
set splitright
set splitkeep=screen

set previewheight=8
set winheight=14
set winminheight=0
set nrformats-=octal
set smarttab
set laststatus=2
set wildmenu
set wildoptions=pum
set pumwidth=30
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
let g:qf_window_bottom = 0
let g:qf_mapping_ack_style = 1
let g:qf_auto_resize = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_open_quickfix = 0
let g:qf_max_height = 8


let g:coc_enable_locationlist = 0

" CtrlP
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_root_markers = ['.git', '.root']
let g:ctrlp_match_window = 'top,order:btt,min:1,max:6,results:20'

let g:jsx_ext_required = 0

" vim:set ft=vim et sw=2:

" GitGutter
"let g:gitgutter_sign_priority = 1
" background colours to match the sign column
let g:gitgutter_set_sign_backgrounds = 0

" let g:quickr_preview_keymaps = 0
let g:quickr_preview_position = 'right'
let g:quickr_preview_size = '0'
let g:quickr_preview_line_hl = "Search"
let g:quickr_preview_options = 'number norelativenumber nofoldenable '
let g:quickr_preview_on_cursor = 1
let g:quickr_preview_exit_on_enter = 1
let g:quickr_preview_modifiable = 0

