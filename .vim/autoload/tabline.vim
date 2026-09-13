if exists("g:mayhem_autoloaded_tabline") || &cp
  finish
endif
let g:mayhem_autoloaded_tabline = 1

"
" See Also: ../plugin/tabline.vim
"           ../plugin/statusline.vim
"

"█▇▆▅▆▇█▅█▅▇▆▇▆
let s:underline_0 = "▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅"
let s:underline_1 = "▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆"
let s:underline_2 = "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇"
let s:underline_3 = "███████████████"
let g:mayhem_tab_underline = s:underline_0
let g:mayhem_curtab_underline = s:underline_1

function! tabline#modstatus(bufnr = bufnr()) abort
  return getbufvar(a:bufnr, "&modified")
        \  ? getbufvar(a:bufnr, "&modifiable")
        \    : '+'
        \    ? '-'
        \  : ''
endfunc

function! tabline#bufname(bufnr = bufnr()) abort
  let bufname = bufname(a:bufnr)
  if empty(bufname)
    let bufname = "𝑢𝑛𝑛𝑎𝑚𝑒𝑑"
  else
    let bufname = fnamemodify(bufname, get(g:, 'mayhem_abbrpaths', ''))
  endif
  return printf(g:mayhem_tl_name_tpl, bufname, tabline#modstatus(a:bufnr))
endfunc

function! tabline#updateCachedBufferName(bufnr = bufnr()) abort
  call setbufvar(a:bufnr, 'mayhem_tl_cached_filename',
        \ tabline#bufname(a:bufnr))
endfunc

function! tabline#updateDiagnostics() abort
  for i in range(1, tabpagenr('$'))
    if !exists('g:did_coc_loaded')
      call settabvar(i, 'mayhem_tl_cached_diag_label',
            \ symbols#inline('diag.off'))
      call settabvar(i, 'mayhem_tl_cached_diag_tip',
            \ symbols#inline('diag.off'))
    else
      let warningCount = 0
      let errorCount = 0

      for bufnr in tabpagebuflist(i)
        let summary = diag#summarise(bufnr)
        let warningCount += get(summary.total, 'warning', 0)
        let errorCount += get(summary.total, 'error', 0)
      endfor

      call settabvar(i, 'mayhem_tl_cached_diag_label',
            \ errorCount > 0 ? printf("%s%s ",
            \ errorCount,
            \ symbols#inline('diag.error')
            \) : symbols#inline('diag.ok')
            \)
      call settabvar(i, 'mayhem_tl_cached_diag_tip', printf("%s%s%s",
        \ errorCount > 0 ? printf("%s%s",
        \   symbols#inline('diag.error'), errorCount) : "",
        \ warningCount > 0 ? printf("%s%s",
        \   symbols#inline('diag.warning'), warningCount) : "",
        \ errorCount == 0 && warningCount == 0 ? symbols#inline('diag.ok') : ""))
    endif
  endfor
endfunc

function! tabline#gen_guitablabel_cache() abort
  let tabul = get(g:, 'mayhem_tab_underline', '')
  let curul = get(g:, 'mayhem_curtab_underline', '')
  for i in range(1, tabpagenr('$'))
    let bufname = get(b:, 'mayhem_tl_cached_filename', tabline#bufname())

    let modified = tabpagebuflist(i)
        \->reduce({acc, bufnr -> acc + getbufvar(bufnr, "&modified", 0)}, 0)

    let current = get(g:, 'actual_curtab', 0) == i

    call settabvar(i, 'mayhem_cache_guitablabel', [
      \printf(" %s", modified ? " ̵̩̩" : " "),
      \printf("%%{%%GuiTabLabelErrors()%%} %%{%%GuiTabLabelName()%%}"),
      \printf("%s", current ? curul : tabul)
      \]->join("\n"))
  endfor
endfunc

"􀏜 􃑷  􃛒  􃛕  􀢌 􃛓  􀾪􁁎 􂃻 􂃼 􂃽 􂃾  􀐑 􀐒   ⎍  ⺇𒋰
        \printf("𝓉𝒶𝒷 %s ℴ𝒻 %s		%%= %%{%%GuiTabToolTipErrors()%%} %%= %d 􀢌",
          \printf("%s 𝔬𝔣 %s 	 􀢌 ×%d %%= %%{%%GuiTabToolTipErrors()%%}  ᯼ ᯽ ᯾ ᮋᮗᮗ ᯎ ᯞ ᯄ ⁀ꩰ⟆⟅ ⟋ ⟍⸺  ꗪꘈ ꘡ꕆ ꔪꔖ⸻    ⸏⸧⺵⼈⼃〱〳〵ヿㆷㆸㆹ乛乁㆟乀艹襾非꠸Ꞁꚨ冖匚臣臦 ᯿ ꜒ᯇᯆ ᯋ ᰨ᯿₀₁₂八㈠᠐೧୮០ᝨᝨᝨ ᝨᝀ ᝑᝊᝏ ᝤ ᜭᜳᜭᜲ ᜱ᜵᜶ᜑ ᜆ ᒥᒣ ᎗ ᅀᄼᄂೲ ୮ଠି ߜߡ؅ᣞ᨞ᩕᩤᨓ ᨓ ᨆᨈᩤ᪂᩷᪂᭼ ˥䷑⎍️ ┌┐╱╲╭─ᝉ─╮⎾⏋⏉⏉_‾‾1̅ ⇥️ ⎎️⅂ᒥ꛱𝟣꛱/͡͡͡꜒ᝈᝈ𝟦꛱𝟧꛱   ᦔ ᧒ᨀᨂᨄ ᨈ ᨆ ᨏᨔ ᨔᨛᨘ ᨂᨉᨛ ᩤ         ꧷ ꩜ ꩳ ꩹   ꩰ ꪚꪜꪝ ꫣ ꫪ ꫳ꯫ﾍﾊﾉﾤﾡｰￛￜￚￂￚￆￓￚ￣￣�𐀏 𐀴𐃘  𐃑𐃑𐃑𐃑  𐃴 𐂮 𐂐 𐃡 𐃝 𐃬 𐍗𐍠𐐑𐐓𐔏𐔕𐕆𐚠𐚢𐡾      𐣫𐣿𐣴 𐨭 𐪂 𐪈 𐪐 𑂝𑃥 𑈸𑊊 𑊃 𑋡𑌟 𑐛 𑙄𑙢𑙩 𑚥𑚆𑚫𑵑𑵗𑿈 𒆸 𒊹 𒌋 𒎙 𒌍 𓉘𓉝 𓊔𓎑 𓎏𓎏𓐞𓏥𓏸𖡦 𖡩𖡡𖡡𖡔𖡍 𖡹 𖢖 𖢗 𖣇 𖣊 𖤂 𖤪 𖣣𖤐 𖥔 𖥦 𖥑𖤱𖥞 𖥭𖥚 𖥣 𖥵 𖤩 𖦛𖧋𖧯𖧯 𖨠 𖧹𖦸𖦹𖦏 𖦷  𖩎𖩐 𖩇𖩉𖮈 𖼆𖼆𖼆 𖼲𖼪𖼲𖼪𖼲𖼪𖼲𖼮𖼦 𖼮𝇋𝇋  𞠣𞡄𞡂𞠥𞡄𞡄𞢕𞣁𞣋𞣐 𞣁𞣐 𞣇𞣐 𞣈𞣐   𖥤    ᪠᪡᪤ ᭥ ᭦ ᮔᮄ ᮄᮔ␣ꁝꇤ꒓ꔷꖜ ꕢ ꖸ ꤷꤶꤱꥁ ꤂꤮ ꤮ ꤯꧊𞣐𞣐꧋꧉꧈꧈꧉꧉꧉ ꧞ꧏꦪ  ꧑ ꧓  ꧔꧕ ꧗ ꧘ ꧙  ꧪ",

function! tabline#gen_guitabtooltip_cache() abort
  for i in range(1, tabpagenr('$'))
    call settabvar(i, 'mayhem_cache_guitabtooltip', [
         \ printf(" ⎩︎⸏𝟤 ⎭︎ ℴ𝒻 ⎩ ̲𝟥̲ ̲⎭   ⎝︎ ̲%s ̲⎠︎ 𝔬𝔣 ⎝ ̲%s ̲⎠ 	 􀢌 ×%d %%= %%{%%GuiTabToolTipErrors()%%}",
        \ format#numbers(string(i), 'sans'),
        \ format#numbers(tabpagenr('$')->string(), 'sans'),
        \ tabpagewinnr(i, '$'),
        \),
        \printf("%s%%<",
        \ tabpagebuflist(i)
        \  ->map({j, bufnr -> getbufvar(bufnr, 'mayhem_tl_cached_filename')})
        \  ->join("\n")
        \),
        \]->join("\n"))
  endfor
endfunc

function! tabline#gen_guitab_caches() abort
  call tabline#gen_guitablabel_cache()
  call tabline#gen_guitabtooltip_cache()
endfunc
