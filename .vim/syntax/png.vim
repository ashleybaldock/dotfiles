"
" Syntax highlighting for PNG files
"
" ! Replaces runtime syntax file
"
" :au BufWritePost <buffer> syn on
"
" Related: $VIMHOME/ftplugin/png.vim
"
" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match pngCritical contained contains=NONE
      \ /\%(IHDR\|PLTE\|IDAT\|IEND\)/


syn match pngAncillary contained contains=NONE
      \ /\%(cHRM\|gAMA\|iCCP\|sBIT\|sRGB\|bKGD\|hIST\|tRNS\|pHYs\|sPLT\|tIME\|iTXt\|tEXt\|zTXt\)/

syn match pngChecksum contained contains=NONE
      \ /.\{4}\ze.\{4}\%(IHDR\|PLTE\|IDAT\|IEND\)/
      " \ nextgroup=pngChunkSize
syn match pngChunkSize contained contains=NONE
      \ /.\{4}\ze\%(IHDR\|PLTE\|IDAT\|IEND\)/
      " \ nextgroup=pngCritical,pngAncillary

syn region pngChunk 
      \ start=/.\{4}\%(IHDR\|PLTE\|IDAT\|IEND\)/
      \ skip=/\_$\_^\x\{8}:\%(\s\x\{4}\)\{8}  /
      \ end=/\ze.\{4}\%(IHDR\|PLTE\|IDAT\|IEND\)/
      \ contains=pngCritical,pngAncillary,pngChunkSize,pngChucksum
      \ fold keepend

" syn match pngChunk /.\{4}\%(IHDR\|PLTE\|IDAT\|IEND\)/
"       \ contains=pngChunkSize,pngChunkName
"       \ nextgroup=pngChunk

syn match pngSignature /\%x89PNG\%x0d\n\%x1a\n/ contains=NONE
syn match pngSignature /\.PNG\.\.\.\./ contains=NONE
syn match pngSignature /8950\s*4e47\s*0d0a\s*1a0a/ contains=NONE

" hi def pngChunk      guibg=#333399
hi def pngChecksum   guibg=#aa0000
hi def pngChunkSize  guibg=#aa7777
hi def pngSignature  guifg=#000000 guibg=#aa99ff
" hi def pngChunk     guibg=#ff99ff
hi def pngCritical   guifg=#000000 guibg=#ffff99
hi def pngAncillary  guibg=#ff9999



let b:current_syntax = "png"

let &cpo = s:cpo_save
unlet s:cpo_save

