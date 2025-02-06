if exists("g:mayhem_loaded_mode")
  finish
endif
let g:mayhem_loaded_mode = 1


" ^V/^S need to be real, i.e. entered using ctrl+v,ctrl+v/ctrl+s
" Single letter mode() - Ascii
function! SimpleModeA() abort
  return {
        \ 'n': 'n',
        \ 'i': 'i',
        \ 'v': 'v', 'V': 'V', '': '^V',
        \ 's': 's', 'S': 'S', '': '^S',
        \ 'R': 'R',
        \ 'r': 'r',
        \ 't': 't',
        \ 'c': 'c',
        \ '!': 'S',
        \ }[mode()]
endfunc

" Single letter mode() - Unicode
function! SimpleMode8() abort
  return {
        \ 'n': 'n',
        \ 'i': 'ɪ',
        \ 'v': 'v', 'V': 'v̅', '': 'v̺͆',
        \ 's': 's', 'S': 's̅', '': 's̺͆',
        \ 'R': 'ʀ',
        \ 'r': 'ᴚ',
        \ 't': 'ʇ',
        \ 'c': 'ɔ',
        \ '!': 'S',
        \ }[mode()]
endfunc

" Single letter mode() - SF Symbols
function! SimpleModeSF() abort
  return {
        \ 'n': 'n',
        \ 'i': 'ɪ',
        \ 'v': 'v', 'V': 'v̅', '': 'v̺͆',
        \ 's': 's', 'S': 's̅', '': 's̺͆',
        \ 'R': 'ʀ',
        \ 'r': 'ᴚ',
        \ 't': 'ʇ',
        \ 'c': 'ɔ',
        \ '!': 'S',
        \ }[mode()]
endfunc

" Multi letter mode(true) - Ascii
function! ModeA() abort
endfunc
" Multi letter mode(true) - Unicode
function! Mode8() abort
endfunc
" Multi letter mode(true) - SF Symbols
function! ModeSF() abort
  return {'n':    '􀂮',
        \ 'no':   '􀂮􀍡',
        \ 'nov':  '􀂮􀍡',
        \ 'noV':  '􀂮􀍡',
        \ 'no': '􀂮􀍡',
        \ 'niI':  '􀈎',
        \ 'niR':  '􀈎',
        \ 'niV':  '􀈎',
        \ 'nt':   '􀩼􀂮',
        \ 'v':    '􀍳',
        \ 'V':    'v̅',
        \ '':   'v̺͆ v⃞',
        \ 'vs':   '',
        \ 'Vs':   '',
        \ 's':  '',
        \ 's':    's',
        \ 'S':    's̅',
        \ '':   's̺͆ s⃞',
        \ 'i':    '􀈎',
        \ 'ic':   '􀈎',
        \ 'ix':   '􀈎',
        \ 'R':    'ʀ',
        \ 'Rc':   'ʀ',
        \ 'Rx':   'ʀ',
        \ 'Rv':   'ʀ',
        \ 'Rvc':  'ʀ',
        \ 'Rvx':  'ʀ',
        \ 'c':    '􀂘',
        \ 'ct':   '􀂘􀩼􀄄',
        \ 'cr':   '􀂘',
        \ 'cv':   '􀕲',
        \ 'cvr':  '􀕲',
        \ 'ce':   '􀕲',
        \ 'r':    '􀅇',
        \ 'rm':   '􀋷',
        \ 'r?':   '􀢰',
        \ 't':    '􀩼􀃼',
        \ '!':    '􀖇',
        \ }[mode(v:true)]
endfunc
