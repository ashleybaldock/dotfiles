if exists("g:mayhem_loaded_dataurl")
  finish
endif
let g:mayhem_loaded_dataurl = 1


"data:image/svg+xml,"

" input to each:
"
" IN: <svg xmlns="http://www.w3.org/2000/svg" viewBox="1 0 20 20"><path d="m4.3 2.9 12.8 12.8-1.4 1.4L2.9 4.3zM17.1 4.3 4.3 17.1l-1.4-1.4L15.7 2.9z"/></svg>



command! EncodeSvgDataUrl :'<,'>!encodeSVG.js `cat`
" OUT: url('data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 12 12%22%3E%3Cpath fill=%22%23202122%22 d=%22m11.05 3.996-.965-1.053-4.035 3.86-3.947-3.86L1.05 3.996l5 5 5-5%22/%3E%3C/svg%3E')



" 'data:image/svg+xml;utf8,%20%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%2021%204%22%20style=%22fill:white;%22%3E%3Cpath%20d=%22m6.5%204%204-4%204%204z%22/%3E%3C/svg%3E'

command! DecodeURI :'<,'>!node -e 'console.log(decodeURI(process.argv.slice(1).join(" ")))' -- `cat`


command! EncodeURI :'<,'>!node -e 'console.log(encodeURI(process.argv.slice(1).join(" ")))' -- `cat`

command! DecodeURIComponent :'<,'>!node -e 'console.log(decodeURIComponent(process.argv.slice(1).join(" ")))' -- `cat`

command! EncodeURIComponent :'<,'>!node -e 'console.log(encodeURIComponent(process.argv.slice(1).join(" ")))' -- `cat`

" data%3Aimage%2Fsvg%2Bxml%2C%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2220%22%20height%3D%2220%22%20style%3D%22fill%3Awhite%3B%22%20viewBox%3D%220%200%2020%2020%22%3E%3Ctitle%3E%20close%20%3C%2Ftitle%3E%3Cpath%20d%3D%22m4.3%202.9%2012.8%2012.8-1.4%201.4L2.9%204.3z%22%2F%3E%3Cpath%20d%3D%22M17.1%204.3%204.3%2017.1l-1.4-1.4L15.7%202.9z%22%2F%3E%3C%2Fsvg%3E
