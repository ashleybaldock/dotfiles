vim9script
if exists("g:mayhem_loaded_quickfix")
  finish
endif
g:mayhem_loaded_quickfix = 1

#
# See Also: ../syntax/qf.vim
#

# const EFM_TYPE = {e: 'error', w: 'warning', i: 'info', n: 'note'}
const EFM_TYPE = {e: 'E', w: 'W', i: 'i', n: 'n'}

# set qftf = QuickFixTextFunc nowrap | syn on
def g:QFTFAlignColumns(info: dict<number>): list<string>
  var qfl: list<any>
  if info.quickfix
    qfl = getqflist({id: info.id, items: 0}).items
  else
    qfl = getloclist(info.winid, {id: info.id, items: 0}).items
  endif
  var l: list<string> = []
  var lnum_w: number = range(info.start_idx - 1, info.end_idx - 1)
    ->map((_, v: number): number => qfl[v].lnum)->max()->len()
  var col_w: number = range(info.start_idx - 1, info.end_idx - 1)
    ->map((_, v: number): number => qfl[v].col)->max()->len()
  var name_w: number = range(info.start_idx - 1, info.end_idx - 1)
    ->map((_, v: number): number => qfl[v].bufnr->bufname()
      ->fnamemodify(':t')->strchars(true))->max()
  var type_w: number = range(info.start_idx - 1, info.end_idx - 1)
    ->map((_, v: number): number => get(EFM_TYPE, qfl[v].type, '')->strlen())->max()
  var err_w: number = range(info.start_idx - 1, info.end_idx - 1)
    ->map((_, v: number): number => qfl[v].nr)->max()->len()

# '⎧ʅ️⎩'

  const s:b_start = get(g:, 'mayhem_qf_bracket_firstline', '⎫')
  const s:b_continue = get(g:, 'mayhem_qf_bracket_midline', '⎪')
  const s:b_end = get(g:, 'mayhem_qf_bracket_lastline', '⎩')
  const s:b_startend = get(g:, 'mayhem_qf_bracket_oneline', 'ʅ️')

  var lastbufnr: number = 0
  for idx in range(info.start_idx - 1, info.end_idx - 1)
    var e: dict<any> = qfl[idx]
    if !e.valid
      add(l, '|| ' .. e.text)
    else
      if e.lnum == 0 && e.col == 0
        add(l, bufname(e.bufnr))
      else
        var bracket: string = s:b_continue
        if e.bufnr != lastbufnr
          bracket = s:b_start
        endif
        if idx >= info.end_idx - 1
          if e.bufnr == lastbufnr
            bracket = s:b_end
          else
            bracket = s:b_startend
          endif
        else
          var enext: dict<any> = qfl[idx + 1]
          if enext.bufnr != e.bufnr
            if e.bufnr == lastbufnr
              bracket = s:b_end
            else
              bracket = s:b_startend
            endif
          endif
        endif
        lastbufnr = e.bufnr

        var name: string = printf('%*S%s ', name_w,
          (bracket == s:b_start || bracket == s:b_startend)
           ? bufname(e.bufnr)->fnamemodify(':t')
           : '', bracket)
        # var fname: string = printf('%-*S', name_w, bufname(e.bufnr)->fnamemodify(':t'))
        var lnum: string = printf('%*d', lnum_w, e.lnum)
        # var col: string = printf('%*d', col_w, e.col)
        var type: string = printf('%-*S', type_w, get(EFM_TYPE, e.type, ''))
        var err = ''
        if e.nr > 0
          err = printf('%*d', err_w + 1, e.nr)
        endif
        # add(l, printf('%s│%s,%s %s%s│ %s', name, lnum, col, type, err, e.text))
        add(l, printf('%s%s %s%s│ %s', name, lnum, type, err, e.text))
      endif
    endif
  endfor
  return l
enddef
# helpg foobar
# copen




