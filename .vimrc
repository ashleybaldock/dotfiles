" To disable a plugin, add it's bundle name to the following list
let g:pathogen_blacklist = []

" Disable plugins on non-gui versions
"if !has('gui_running')
"  call add(g:pathogen_blacklist, 'csscolor')
"endif

execute pathogen#infect()

set t_Co=256
set background=dark
syntax enable
filetype plugin indent on

set ts=2 sts=2 sw=2 et
au BufRead,BufNewFile ~/keylines/* setlocal ts=2 sts=2 sw=2
set enc=utf8
filetype on
set hlsearch
syn on
set mouse=a
set backspace=indent,eol,start

set timeout
set timeoutlen=600

if has('gui_running')
  " GUI only
  set guioptions-=rL
  set guioptions+=c
  set guicursor+=a:blinkon0
  set noantialias
  set guifont=Monaco:h10
  colorscheme murphy
else
  " Console only
  set ttyfast

  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

set synmaxcol=256

set nrformats-=octal
set smarttab
set incsearch
set laststatus=2
set wildmenu
set display+=lastline
set autoread
set showcmd

" Display line movements, except with count
set breakindent
set showbreak=\\\\\
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

set updatetime=1000

" Use <C-L> to clear the highlighting of :set hlsearch.
"if maparg('<C-L>', 'n') ==# ''
"  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
"endif
" au FileType qf wincmd J " QuickFix window always at bottom

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion=1
" Bind key to quickly restart completion engine
map <leader>yr :YcmRestartServer<CR>
map <leader>g  :YcmCompleter GoTo<CR>
map <leader>rr :YcmCompleter RefactorRename 

map <leader>L  :set list!<CR>
map <leader>e  :Explore<CR>
map <leader>es :Sexplore<CR>
map <leader>ev :Vexplore<CR>
map <leader>t  :set guifont=Monaco:h10<CR>
map <leader>T  :set guifont=Monaco:h16<CR>

" Save files as root when vim isn't

function! s:BufferCount() abort
  return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

function! ToggleLoclist()
  let bufcount = s:BufferCount()
  silent! lcl
  if s:BufferCount() == bufcount
    execute "silent! lop "
  endif
endfunction

function! ToggleQuickfix()
  let bufcount = s:BufferCount()
  silent! ccl
  if s:BufferCount() == bufcount
    execute "silent! :bo cope "
  endif
endfunction

map <leader>q  :call ToggleQuickfix()<CR>
map <leader>l  :call ToggleLoclist()<CR>

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

" Set working directory to current file
au BufEnter * silent! lcd %:p:h

au BufEnter *.py set ts=4 sts=4 sw=4 et
au BufEnter *.pyw set ts=4 sts=4 sw=4 et

set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
set list

au FileType netrw set nolist
au FileType gitcommit set nolist
"au FileType netrw au BufEnter <buffer> set nolist
"au FileType netrw au BufLeave <buffer> set list

let g:jsx_ext_required = 0

" ALE
" For a more fancy ale statusline
" https://github.com/liuchengxu/space-vim/blob/master/layers/%2Bcheckers/syntax-checking/config.vim
function! ALEGetError()
  if exists('g:loaded_ale')
    let l:res = ale#statusline#Status()
    if l:res ==# 'OK'
      return ''
    else
      let l:e_w = split(l:res)
      if len(l:e_w) == 2 || match(l:e_w, 'E') > -1
        return ' ‡' . matchstr(l:e_w[0], '\d\+') .' '
      endif
    endif
  endif
  return ''
endfunction
function! ALEGetWarning()
  if exists('g:loaded_ale')
    let l:res = ale#statusline#Status()
    if l:res ==# 'OK'
      return ''
    else
      let l:e_w = split(l:res)
      if len(l:e_w) == 2
        return ' •' . matchstr(l:e_w[1], '\d\+')
      elseif match(l:e_w, 'W') > -1
        return ' •' . matchstr(l:e_w[0], '\d\+')
      endif
    endif
  endif
  return ''
endfunction
function! ALEGetOk()
  if exists('g:loaded_ale')
    let l:res = ale#statusline#Status()
    if l:res == 'OK'
      return 'ok'
    endif
  endif
  return ''
endfunction
let g:ale_linters = {
\  'javascript': ['eslint']
\}
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_lint_delay = 300
let g:ale_lint_on_enter = 1
let g:ale_set_signs = 0
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_lint_on_insert_leave = 1

" Fugitive
function! S_fugitive()
  if exists('g:loaded_fugitive')
    let l:head = fugitive#head()
    return empty(l:head) ? '' : '  ⎇ '.l:head . ' '
  endif
  return ''
endfunction

" Status line
hi ale_error   cterm=None ctermfg=197 ctermbg=237 gui=None guifg=#CC0033 guibg=#3a3a3a
hi ale_warning cterm=None ctermfg=214 ctermbg=237 gui=None guifg=#FFFF66 guibg=#3a3a3a
hi ale_ok      cterm=None ctermfg=LightGreen ctermbg=237 gui=None guifg=#00FF66 guibg=#3a3a3a

" start of default statusline
set statusline=%f\ %h%w%m%r\ 
" ALE statusline
"set statusline+=%#warningmsg#%{ALEGetStatusLine()}
set statusline+=%#ale_error#%{ALEGetError()}%*
set statusline+=%#ale_warning#%{ALEGetWarning()}%*
set statusline+=%#ale_ok#%{ALEGetOk()}%*
" end of default statusline (with ruler)
set statusline+=%{S_fugitive()}
set statusline+=%=%(%l,%c%V\ %=\ %P%)\ 

" vim:set ft=vim et sw=2:
