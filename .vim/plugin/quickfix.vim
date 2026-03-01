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

  const s1l1 = get(g:, 'mayhem_qf_sep1_firstline', '⎫')
  const s1lm = get(g:, 'mayhem_qf_sep1_midline',   '⎪')
  const s1le = get(g:, 'mayhem_qf_sep1_lastline',  '⎩')
  const s1lo = get(g:, 'mayhem_qf_sep1_oneline',   'ʅ️')

  const s2l1 = get(g:, 'mayhem_qf_sep2_firstline', ':️')
  const s2lm = get(g:, 'mayhem_qf_sep2_midline',   '·️')
  const s2le = get(g:, 'mayhem_qf_sep2_lastline',  '_')
  const s2lo = get(g:, 'mayhem_qf_sep2_oneline',   '_')

  var lastbufnr: number = 0
  for idx in range(info.start_idx - 1, info.end_idx - 1)
    var e: dict<any> = qfl[idx]
    if !e.valid
      add(l, '|| ' .. e.text)
    else
      if e.lnum == 0 && e.col == 0
        add(l, bufname(e.bufnr))
      else
        var sep1: string = s1lm
        var sep2: string = s2lm
        if e.bufnr != lastbufnr
          sep1 = s1l1
          sep2 = s2l1
        endif
        if idx >= info.end_idx - 1
          if e.bufnr == lastbufnr
            sep1 = s1le
            sep2 = s2le
          else
            sep1 = s1lo
            sep2 = s2lo
          endif
        else
          var enext: dict<any> = qfl[idx + 1]
          if enext.bufnr != e.bufnr
            if e.bufnr == lastbufnr
              sep1 = s1le
              sep2 = s2le
            else
              sep1 = s1lo
              sep2 = s2lo
            endif
          endif
        endif
        lastbufnr = e.bufnr

        var name: string = printf('%*S%s ', name_w,
          (sep1 == s1l1 || sep1 == s1lo)
           ? bufname(e.bufnr)->fnamemodify(':t')
           : '', sep1)
        # var fname: string = printf('%-*S', name_w, bufname(e.bufnr)->fnamemodify(':t'))
        var lnum: string = printf('%*d', lnum_w, e.lnum)
        # var col: string = printf('%*d', col_w, e.col)
        var type: string = printf('%-*S', type_w, get(EFM_TYPE, e.type, ''))
        var err = ''
        if e.nr > 0
          err = printf('%*d', err_w + 1, e.nr)
        endif
        # add(l, printf('%s│%s,%s %s%s│ %s', name, lnum, col, type, err, e.text))
        add(l, printf('%s%s %s%s%s %s', name, lnum, type, err, sep2, e.text))
      endif
    endif
  endfor
  return l
enddef
# helpg foobar
# copen




