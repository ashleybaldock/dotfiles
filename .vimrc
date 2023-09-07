
set encoding=utf-8

nnoremap <leader>o   <C-o>
nnoremap <leader>L   :set list!<CR>
nnoremap <leader>e   :Explore<CR>
nnoremap <leader>es  :Sexplore<CR>
nnoremap <leader>ev  :Vexplore<CR>
nnoremap <leader>t   :set guifont=Menlo:h12<CR>
nnoremap <leader>tt  :set guifont=Menlo:h14<CR>
nnoremap <leader>ttt :set guifont=Menlo:h16<CR>

"Repeat last edit n times
nnoremap . :<C-u>execute "norm! " . repeat(".", v:count1)<CR>

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
  set guioptions-=rL
  set guioptions+=ck
  set guicursor+=a:blinkon0
  set noantialias
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
set shortmess+=sAIt

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

" Delete comment character when joining commented lines
set formatoptions+=j

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

" search up to root when using gf, opening files etc.
set path+=;~

" Seach current buffer
" word under cursor
"   hl    +prev  +next
"   \\       *      #   (word boundaries)
"   \\\     g*     g#   (anywhere)
" visual selection:
"   prev  next
"     *     #  anywhere
" Put word under cursor into search register and highlight
nnoremap <silent> <Leader>\ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" vnoremap <silent> <Leader>* :<C-U>
"   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
"   \gvy:let @/=substitute(
"   \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>
"   \gV:call setreg('"', old_reg, old_regtype)<CR>:set hls<CR>

" Search across files
" Get a useful search root folder
" - parent git dir
" - folder patterns
:function! ProjectRoot()
  let l:root_dirs = ['.git']
  let l:root_files = ['.root', '.gitignore']
  for l:item in l:root_dirs
    let l:dirs = finddir(l:item, '.;~', -1)
    if !empty(l:dirs)
      return fnameescape(fnamemodify(l:dirs[-1].'/../', ':p:h'))
    endif
  endfor
  for l:item in l:root_files
    let l:files = findfile(l:item, '.;~', -1)
    if !empty(l:files)
      return fnameescape(fnamemodify(l:files[-1], ':p:h'))
    endif
  endfor
  return getcwd()
:endfunction
:command! -bar ProjectRoot :echo ProjectRoot()

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev Ack Ack!
cnoreabbrev ag call ProjectRoot() <bar> Ack! -Q 
nnoremap <Leader>a :Ack!<Space>
" • = ⌥ + *
nnoremap # :exec 'cd' ProjectRoot() <bar> Ack! <C-r><C-w><CR>
nnoremap • :exec 'cd' ProjectRoot() <bar> Ack! <C-r><C-w><CR>
nnoremap <Leader>' :exec 'cd' ProjectRoot() <bar> Ack! <C-r><C-w><CR>
nnoremap <Leader>" :exec 'cd' ProjectRoot() <bar> Ack! <C-r>/<CR>

" CtrlP
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_root_markers = ['.git', '.root']
let g:ctrlp_match_window = 'top,order:btt,min:1,max:10,results:10'
nnoremap <S-tab>     :CtrlP<CR>
nnoremap <leader>p   :CtrlP<CR>


" Filetype: Python
augroup python_commands
  autocmd!
  " au BufEnter *.py set ts=4 sts=4 sw=4 et
  " au BufEnter *.pyw set ts=4 sts=4 sw=4 et
  au BufEnter *.py set ts=2 sts=2 sw=2 et
  au BufEnter *.pyw set ts=2 sts=2 sw=2 et
augroup END

" Filetype: JavaScript
augroup js_commands
  autocmd!
  au FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
augroup END
let g:jsx_ext_required = 0

" vim:set ft=vim et sw=2:

" GitGutter
"let g:gitgutter_sign_priority = 1
" background colours to match the sign column
let g:gitgutter_set_sign_backgrounds = 0

if has('gui_running')
  colorscheme vividmayhem
else
  colorscheme vividchalk
endif
