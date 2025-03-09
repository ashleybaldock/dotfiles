if exists("g:mayhem_loaded_templates")
  finish
endif
let g:mayhem_loaded_templates = 1

if !exists('g:mayhem_dir_template')
  echom 'Template directory not defined (g:mayhem_dir_template)'
  let g:mayhem_loaded_templates = 2
  finish
endif

if !isdirectory(g:mayhem_dir_template)
  echom 'templates dir ''' .. g:mayhem_dir_template
        \ .. '''not found- creating it'
  call mkdir(g:mayhem_dir_template, "p", 0711)
endif

function s:InsertTemplate(filename)
  let l:ext = fnamemodify(a:filename, ':e')
  let l:head = fnamemodify(a:filename, ':t:r')
  silent! exec
        \ '0r ~/.vim/templates/'
        \ .. l:ext .. '.template'

  " Replace tokens in template
  " Filename:
  "  as-is
  silent! exec '%s/%FILE%/' .. l:head .. '/g'
  "  lowercase (FileName -> filename)
  silent! exec '%s/%FILE:LC%/' .. tolower(l:head) .. '/g'
  "  UPPERCASE (FileName -> FILENAME)
  silent! exec '%s/%FILE:UC%/' .. toupper(l:head) .. '/g'
  "  Title Case (fn -> Fn, fiNm -> FiNm, fi_nm -> FiNm)
  silent! exec '%s/%FILE:TC%/' .. 
        \ split(l:head, '\([_ .-]\|\ze[A-Z]\)')->map(
        \  {_, v -> substitute(v,'\(.\)\(.*\)', '\u\1\2', 'g')}
        \)->join('') .. '/g'
  "  Split Title Case (fn -> Fn, fiNm -> Fi Nm, fi_nm -> Fi Nm)
  silent! exec '%s/%FILE:STC%/' ..
        \ split(l:head, '\([_ .-]\|\ze[A-Z]\)')->map(
        \  {_, v -> substitute(v,'\(.\)\(.*\)', '\u\1\2', 'g')}
        \)->join(' ') .. '/g'

  " Date And Time:
  "  current date, DD-MM-YYYY
  silent! exec '%s/%DATE%/' .. strftime("%d-%m-%Y") .. '/g'
  "  current date, DD-MM-YYYY
  silent! exec '%s/%TIME%/' .. strftime("%I:%M") .. '/g'

  " Source template init script if present
  silent! exec 'source ~/.vim/templates/'
        \ .. l:ext .. '.template.vim'
endfunc

function! s:TemplateComplete(ArgLead, CmdLine, CursorPos)
  return map(globpath(g:mayhem_dir_template,
        \   a:ArgLead .. "*" .. &l:filetype .. ".template",
        \ 0, 1), {_, val -> fnamemodify(val, ":t:r:r")})
endfunc

command! -nargs=1 -complete=customlist,<SID>TemplateComplete 
      \ InsertTemplate call <SID>InsertTemplate(<f-args>)

augroup MayhemTemplates
  autocmd!
  " Read template skeleton with matching filename
  autocmd BufNewFile *.* call s:InsertTemplate(expand('<afile>'))
augroup END
