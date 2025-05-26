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
  silent! exec '%s/%FILE:LC%/' .. tolower(l:head) .. '/g'

  "
  "  %FILE:LUC% - spaced lowercase ([fiNm, FiNm, Fi Nm, fi_nm, fi-nm] -> fi nm)
  " TODO

  "
  "  %FILE:UC% - UPPERCASE (FileName -> FILENAME)
  "
  silent! exec '%s/%FILE:UC%/' .. toupper(l:head) .. '/g'

  "
  "  %FILE:SUC% - SPACED UPPERCASE ([fiNm, FiNm, Fi Nm, fi_nm, fi-nm] -> FI NM)
  " TODO

  "
  "  %FILE:TC% - TitleCase (fn -> Fn, [fiNm, Fi Nm] -> FiNm)
  "
  silent! exec '%s/%FILE:TC%/' .. 
        \ split(l:head, '\([_ .-]\|\ze[A-Z]\)')->map(
        \  {_, v -> substitute(v,'\(.\)\(.*\)', '\u\1\2', 'g')}
        \)->join('') .. '/g'

  "
  "  %FILE:STC% - Spaced Title Case (fn -> Fn, [fiNm, Fi Nm] -> Fi Nm)
  "
  silent! exec '%s/%FILE:STC%/' ..
        \ split(l:head, '\([_ .-]\|\ze[A-Z]\)')->map(
        \  {_, v -> substitute(v,'\(.\)\(.*\)', '\u\1\2', 'g')}
        \)->join(' ') .. '/g'

  "
  "  %FILE:SC% - snake_case (fn -> fn, [fiNm, Fi Nm] -> fi_nm)
  " TODO
 
  "
  "  %FILE:SSC% - SCREAMING_SNAKE_CASE (fn -> FN, [fiNm, Fi Nm] -> FI_NM)
  " TODO
 
  "
  "  %FILE:KC% - kebab-case (fn -> fn, [fiNm, Fi Nm] -> fi-nm)
  " TODO

  "
  "  %FILE:CC% - camelCase ([FiNm, fi nm] -> fiNm)
  " TODO

  "
  "  %FILE:PC% - PascalCase ([fiNm, fi nm] -> FiNm)
  " TODO (probably identical to TitleCase)


  " Date And Time:
  "
  "  current date, DD-MM-YYYY
  "
  silent! exec '%s/%DATE%/' .. strftime("%d-%m-%Y") .. '/g'

  "
  "  current time, HH:mm
  "
  silent! exec '%s/%TIME%/' .. strftime("%I:%M") .. '/g'

  "
  " %Y-%m-%dT%H:%M:%S.%f
  "

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
