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
  colorscheme vividchalk
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

" OmniSharp
let g:OmniSharp_server_path = '/Users/ashley/.omnisharp/OmniSharp.exe'
let g:OmniSharp_server_type = 'roslyn'
let g:OmniSharp_timeout = 10
let g:OmniSharp_start_without_solution = 1
let g:OmniSharp_prefer_global_sln = 1
"let g:omnisharp_proc_debug = 1
augroup omnisharp_commands
  autocmd!

  au FileType cs setlocal omnifunc=OmniSharp#Complete

  " automatic syntax check on events
  au BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

  "The following commands are contextual, based on the current cursor
  "position.
  au FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
  au FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
  au FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
  au FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
  au FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
  "finds members in the current buffer
  au FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
  " cursor can be anywhere on the line containing an issue
  au FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
  au FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
  au FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
  au FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
augroup END

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
" " Run code actions with text selected in visual mode to extract method
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>
" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>
" " rename without dialog - with cursor on the symbol to rename... ':Rename
" newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>
" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
" Enable snippet completion, requires completeopt-=preview
let g:OmniSharp_want_snippet=1

" YouCompleteMe
"let g:ycm_autoclose_preview_window_after_insertion=1
" Bind key to quickly restart completion engine
"map <leader>yr :YcmRestartServer<CR>
"map <leader>g  :YcmCompleter GoTo<CR>
"map <leader>rr :YcmCompleter RefactorRename 
"
"map <leader>L  :set list!<CR>
"map <leader>e  :Explore<CR>
"map <leader>es :Sexplore<CR>
"map <leader>ev :Vexplore<CR>
"map <leader>t  :set guifont=Monaco:h10<CR>
"map <leader>T  :set guifont=Monaco:h16<CR>

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

" Supertab/completion options
" Enter selects visible menu item in autocomplete
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
set completeopt=longest,menuone
"set completeopt-=preview
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
let g:SuperTabClosePreviewOnPopupClose = 1
set splitbelow

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

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

" Filetype: C#
let g:syntastic_cs_checkers = ['code_checker']

" ALE
" For a more fancy ale statusline
" https://github.com/liuchengxu/space-vim/blob/master/layers/%2Bcheckers/syntax-checking/config.vim
function! ALEGetError()
  if exists('g:loaded_ale')
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    return l:all_errors == 0 ? '' : printf(' ‡%d ', l:all_errors)
  endif
  return ''
endfunction
function! ALEGetWarning()
  if exists('g:loaded_ale')
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_warnings = l:counts.warning + l:counts.style_warning
    return l:all_warnings == 0 ? '' : printf(' •%d ', l:all_warnings)
  endif
  return ''
endfunction
function! ALEGetOk()
  if exists('g:loaded_ale')
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:issues = l:counts.error + l:counts.style_error + l:counts.warning + l:counts.style_warning
    return l:issues == 0 ? ' ok ' : ''
  endif
  return ''
endfunction
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'cs': []
\}
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_lint_delay = 300
let g:ale_lint_on_enter = 1
let g:ale_set_signs = 0
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_lint_on_insert_leave = 1

" Syntastic
function! SYNGetError()
  if exists(':SyntasticCheck')
    let l:res = SyntasticStatuslineFlag()
    let l:e_w = split(l:res, ',')
    if l:res !=# '' && l:e_w[0] !=# 'E0'
      return ' ‡' . matchstr(l:e_w[0], '\d\+') .' '
    endif
  endif
  return ''
endfunction
function! SYNGetWarning()
  if exists(':SyntasticCheck')
    let l:res = SyntasticStatuslineFlag()
    let l:e_w = split(l:res, ',')
    if l:res !=# '' && l:e_w[1] !=# 'W0'
      return ' •' . matchstr(l:e_w[1], '\d\+') .' '
    endif
  endif
  return ''
endfunction
function! SYNGetOk()
  if exists(':SyntasticCheck')
    let l:res = SyntasticStatuslineFlag()
    let l:e_w = split(l:res, ',')
    if l:res !=# '' && l:e_w[0] ==# 'E0' && l:e_w[1] ==# 'W0'
      return 'ok'
    endif
  endif
  return ''
endfunction
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_stl_format = "E%e,W%w"

" Fugitive
function! S_fugitive()
  if exists('g:loaded_fugitive')
    let l:head = fugitive#head()
    return empty(l:head) ? '' : '  ⎇ '.l:head . ' '
  endif
  return ''
endfunction

" Status line
hi syn_error cterm=None ctermfg=197 ctermbg=237 gui=None guifg=#CC0033 guibg=#3a3a3a
hi syn_warn  cterm=None ctermfg=214 ctermbg=237 gui=None guifg=#FFFF66 guibg=#3a3a3a
hi syn_ok    cterm=None ctermfg=LightGreen ctermbg=237 gui=None guifg=#00FF66 guibg=#3a3a3a

" start of default statusline
set statusline=%f\ %h%w%m%r\ 
" ALE statusline
set statusline+=%#syn_error#%{ALEGetError()}%*
set statusline+=%#syn_warn#%{ALEGetWarning()}%*
set statusline+=%#syn_ok#%{ALEGetOk()}%*
" Syntastic statusline
set statusline+=%#syn_error#%{SYNGetError()}%*
set statusline+=%#syn_warn#%{SYNGetWarning()}%*
set statusline+=%#syn_ok#%{SYNGetOk()}%*
" end of default statusline (with ruler)
set statusline+=%{S_fugitive()}
set statusline+=%=%(%l,%c%V\ %=\ %P%)\ 

" vim:set ft=vim et sw=2:
