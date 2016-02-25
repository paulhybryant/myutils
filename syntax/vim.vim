syn keyword vimCommand contained NeoBundle NeoBundleFetch NeoBundleLazy NeoBundleCheck NeoBundleLocal NeoBundleDisable Glaive

function! GetVimFoldText()
  let l:firstline = getline(v:foldstart)
  if l:firstline =~# '\v^\s*" \{\{\{[0-9]$'
    let l:secondline = getline(v:foldstart + 1)
    if l:secondline =~# '\v^\s*NeoBundle'
      if l:secondline =~# '\v.*(\{|\.)$'
        for i in range(v:foldstart + 1, v:foldend)
          let l:commentline = getline(i)
          if l:commentline =~# '\v^\s*\\ \}'
            let l:name = matchstr(l:secondline, "\\v^\\s*NeoBundle \\zs('[^']*')\\ze")
            let l:comment = matchstr(l:commentline, '\v^\s*\\ \}\s*"(\zs.*\ze)')
            return foldtext() . l:name . ':' . l:comment . ' '
          endif
        endfor
        return foldtext()
      else
        let l:matches = matchlist(l:secondline, "\\v^\\s*NeoBundle ('[^']*')[^\"]*\\s*\"(.*)")
        let l:name = l:matches[1]
        let l:comment = l:matches[2]
        return foldtext() . l:name . ':' . l:comment . ' '
      endif
    endif
  endif
  return foldtext()
endfunction

setlocal foldtext=GetVimFoldText()
