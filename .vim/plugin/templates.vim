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
  let l:subtype = mayhem#getSubtypeForPath(a:filename)
  let l:ext = fnamemodify(a:filename, ':e')
  let l:head = fnamemodify(a:filename, ':t:r')
  let l:type = (l:subtype == '' ? '' : l:subtype .. '.') .. l:ext

  let l:template = g:mayhem_dir_template .. '/' .. l:type .. '.template'
  let l:script = g:mayhem_dir_template .. '/' .. l:type .. '.template.vim'

  silent! exec '0r' l:template

  " Replace tokens in template
  " Filename:
  "
  "  %FILE% - as-is
  "
  silent! exec '%s/%FILE%/' .. l:head .. '/g'

  "
  "  %FILE:LC% - lowercase (FileName -> filename)
  "
  silent! exec '%s/%FILE:LC%/' .. format#lowercase(l:head) .. '/g'

  "
  "  %FILE:SLC% - spaced lowercase ([fiNm, FiNm, Fi Nm, fi_nm, fi-nm] -> fi nm)
  "
  silent! exec '%s/%FILE:SLC%/' .. format#spacedlowercase(l:head) .. '/g'

  "
  "  %FILE:UC% - UPPERCASE (FileName -> FILENAME)
  "
  silent! exec '%s/%FILE:UC%/' .. format#uppercase(l:head) .. '/g'

  "
  "  %FILE:SUC% - SPACED UPPERCASE ([fiNm, FiNm, Fi Nm, fi_nm, fi-nm] -> FI NM)
  "
  silent! exec '%s/%FILE:SUC%/' .. format#spaceduppercase(l:head) .. '/g'

  "
  "  %FILE:TC% - TitleCase (fn -> Fn, [fiNm, Fi Nm] -> FiNm)
  "
  silent! exec '%s/%FILE:TC%/' .. format#titlecase(l:head) .. '/g'

  "
  "  %FILE:STC% - Spaced Title Case (fn -> Fn, [fiNm, Fi Nm] -> Fi Nm)
  "
  silent! exec '%s/%FILE:STC%/' .. format#spacedtitlecase(l:head) .. '/g'

  "
  "  %FILE:SC% - snake_case (fn -> fn, [fiNm, Fi Nm] -> fi_nm)
  "
  silent! exec '%s/%FILE:SC%/' .. format#snakecase(l:head) .. '/g'
 
  "
  "  %FILE:SSC% - SCREAMING_SNAKE_CASE (fn -> FN, [fiNm, Fi Nm] -> FI_NM)
  "
  silent! exec '%s/%FILE:SSC%/' .. format#screamingsnakecase(l:head) .. '/g'
 
  "
  "  %FILE:KC% - kebab-case (fn -> fn, [fiNm, Fi Nm] -> fi-nm)
  "
  silent! exec '%s/%FILE:KC%/' .. format#kebabcase(l:head) .. '/g'

  "
  "  %FILE:CC% - camelCase ([FiNm, fi nm] -> fiNm)
  "
  silent! exec '%s/%FILE:CC%/' .. format#camelcase(l:head) .. '/g'

  "
  "  %FILE:PC% - PascalCase ([fiNm, fi nm] -> FiNm)
  "
  silent! exec '%s/%FILE:PC%/' .. format#pascalcase(l:head) .. '/g'


  " Date And Time:
  "
  "  %DATE% - current date, DD-MM-YYYY
  "
  silent! exec '%s/%DATE%/' .. strftime("%d-%m-%Y") .. '/g'

  "
  "  %TIME% - current time, HH:mm
  "
  silent! exec '%s/%TIME%/' .. strftime("%I:%M") .. '/g'

  "
  " %Y-%m-%dT%H:%M:%S.%f
  "

  "
  " Position Cursor:
  "
  " %CUR%
  silent! exec '%s/%CUR%//g'

  " Script:
  " Source template init script if present
  silent! exec 'source' l:script

  echo 'Template inserted:' l:template
endfunc

function! s:TemplateComplete(ArgLead, CmdLine, CursorPos)
  return map(globpath(g:mayhem_dir_template,
        \   a:ArgLead .. "*" .. &l:filetype .. ".template",
        \ 0, 1), {_, val -> fnamemodify(val, ":t:r:r")})
endfunc

command! -nargs=1 -complete=customlist,<SID>TemplateComplete 
      \ Template call <SID>InsertTemplate(<args>)

call autocmd_add([
      \#{
      \ event: 'BufNewFile', pattern: '*.*',
      \ cmd: 'call s:InsertTemplate(expand(''<afile>''))',
      \ group: 'mayhem_templates', replace: v:true,
      \},
      \])
