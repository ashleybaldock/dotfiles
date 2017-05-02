execute pathogen#infect()
set t_Co=256
set background=dark
syntax enable
filetype plugin indent on

set ts=4 sts=4 sw=4 et
au BufRead,BufNewFile ~/keylines/* setlocal ts=2 sts=2 sw=2
set enc=utf8
filetype on
set hlsearch
syn on
set mouse=a

set guioptions-=rL
set guioptions+=c
set guicursor+=a:blinkon0

set ttyfast
set lazyredraw
set synmaxcol=256

set nrformats-=octal
set smarttab
set incsearch
set laststatus=2
set wildmenu
set display+=lastline
set autoread

set ttimeout
set ttimeoutlen=100
set updatetime=250

" Use <C-L> to clear the highlighting of :set hlsearch.
"if maparg('<C-L>', 'n') ==# ''
"  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
"endif
au FileType qf wincmd J " QuickFix window always at bottom

" YouCompleteMe
" Bind key to quickly restart completion engine
nnoremap <silent> <C-M> :YcmRestartServer<CR>

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
        return ' •' . matchstr(l:e_w[0], '\d\+') .' '
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
set statusline+=%=%(%l,%c%V\ %=\ %P%)

" vim:set ft=vim et sw=2:
