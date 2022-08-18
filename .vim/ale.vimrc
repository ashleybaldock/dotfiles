
"nnoremap <C-g><C-h> :ALEFix<CR>
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

"let g:ale_completion_enabled = 1
let g:ale_linters = {
\  'javascript': ['tsserver', 'prettier', 'eslint'],
\  'css': ['prettier'],
\  'scss': ['prettier'],
\  'less': ['prettier'],
\  'json': ['prettier'],
\  'typescript': ['tsserver'],
\  'cs': []
\}
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_delay = 300
let g:ale_fixers = {
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
\  'javascript': ['eslint', 'prettier'],
\  'typescript': ['tslint', 'prettier'],
\}
"let g:ale_fix_on_save = 1
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_echo_msg_format = '[%linter%] %severity%: %s'
let g:ale_set_signs = 0
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_set_highlights = 1
"highlight ALEError ctermbg=88
highlight link ALEError SpellBad
highlight link ALEWarning SpellCap
