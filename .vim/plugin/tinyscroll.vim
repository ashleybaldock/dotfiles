if exists("g:mayhem_loaded_tinyscroll")
  finish
endif
let g:mayhem_loaded_tinyscroll = 1

scriptencoding utf-8


let g:mayhem = get(g:, 'mayhem', {})
let g:mayhem.sl = get(g:mayhem, 'sl', {})

let g:mayhem.symbols_S = get(g:mayhem, 'symbols_S', {})
let g:mayhem.symbols_8 = get(g:mayhem, 'symbols_8', {})
let g:mayhem.symbols_A = get(g:mayhem, 'symbols_A', {})

let g:mayhem.symbols_8.scrollL = {
      \ 'steps': ['꜒','꜍','꜓','꜎','꜔','꜐','꜕','꜑','꜖'],
      \ 'top':'꜒̅', 'full':'▫̲̅', 'bot':'꜖̲', 'none': '▫',
      \ }
let g:mayhem.symbols_8.scrollR = {
      \ 'steps': ['˥','꜈','˦','꜉','˧','꜋','˨','꜌','˩'],
      \ 'top':'˥̅', 'full':'▫̲̅', 'bot':'˩̲', 'none': '▫',
      \ }
let g:mayhem.symbols_S.scroll = g:mayhem.symbols_8.scrollR
let g:mayhem.symbols_8.scroll = g:mayhem.symbols_8.scrollR
let g:mayhem.symbols_A.scroll = {
      \ 'steps': ['1','2','3','4','5','6','7','8','9'],
      \ 'top':'¯', 'full':']', 'bot':'_', 'none': '=',
      \ }

let s:symbols = GetBestSymbols()

function! ScrollHint() abort
  let scrollsymbols = get(s:symbols, 'scroll', {})
  let line_cursor = line('.')
  let line_wintop = line('w0')
  let line_winbot = line('w$')
  let line_count  = line('$')
  let winheight = winheight(winnr())
  let lines_visible = line('w$') - line('w0') + 1

  if winheight < 1 || lines_visible < 1
    return scrollsymbols.none
  endif
  if line_wintop == 1
    if line_winbot == line_count
      return scrollsymbols.full
    endif
    return scrollsymbols.top
  endif
  if line_winbot == line_count
    return scrollsymbols.bot
  endif

  let position = (line_cursor * len(scrollsymbols.steps) - 1) / line_count

  let top    = line('w0')
  let height = line('w$') - top + 1

  " echo printf('%i, %i, %i, %s',
  "\ line_cursor, line_count, position, scrollsymbols.steps[position])
  return scrollsymbols.steps[position]
endfunc

