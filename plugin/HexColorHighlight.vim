let s:HexColored = 0
let s:HexColors = []

" returns an approximate grey index for the given grey level
function! <SID>grey_number(x)
  if &t_Co == 88
    if a:x < 23
      return 0
    elseif a:x < 69
      return 1
    elseif a:x < 103
      return 2
    elseif a:x < 127
      return 3
    elseif a:x < 150
      return 4
    elseif a:x < 173
      return 5
    elseif a:x < 196
      return 6
    elseif a:x < 219
      return 7
    elseif a:x < 243
      return 8
    else
      return 9
    endif
  else
    if a:x < 14
      return 0
    else
      let l:n = (a:x - 8) / 10
      let l:m = (a:x - 8) % 10
      if l:m < 5
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfunction

" returns the actual grey level represented by the grey index
function! <SID>grey_level(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 46
    elseif a:n == 2
      return 92
    elseif a:n == 3
      return 115
    elseif a:n == 4
      return 139
    elseif a:n == 5
      return 162
    elseif a:n == 6
      return 185
    elseif a:n == 7
      return 208
    elseif a:n == 8
      return 231
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 8 + (a:n * 10)
    endif
  endif
endfunction

" returns the palette index for the given grey index
function! <SID>grey_color(n)
  if &t_Co == 88
    if a:n == 0
      return 16
    elseif a:n == 9
      return 79
    else
      return 79 + a:n
    endif
  else
    if a:n == 0
      return 16
    elseif a:n == 25
      return 231
    else
      return 231 + a:n
    endif
  endif
endfunction

" returns an approximate color index for the given color level
function! <SID>rgb_number(x)
  if &t_Co == 88
    if a:x < 69
      return 0
    elseif a:x < 172
      return 1
    elseif a:x < 230
      return 2
    else
      return 3
    endif
  else
    if a:x < 75
      return 0
    else
      let l:n = (a:x - 55) / 40
      let l:m = (a:x - 55) % 40
      if l:m < 20
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfunction

" returns the actual color level for the given color index
function! <SID>rgb_level(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 139
    elseif a:n == 2
      return 205
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 55 + (a:n * 40)
    endif
  endif
endfunction

" returns the palette index for the given R/G/B color indices
function! <SID>rgb_color(x, y, z)
  if &t_Co == 88
    return 16 + (a:x * 16) + (a:y * 4) + a:z
  else
    return 16 + (a:x * 36) + (a:y * 6) + a:z
  endif
endfunction

" returns the palette index to approximate the given R/G/B color levels
function! <SID>color(r, g, b)
  " get the closest grey
  let l:gx = <SID>grey_number(a:r)
  let l:gy = <SID>grey_number(a:g)
  let l:gz = <SID>grey_number(a:b)

  " get the closest color
  let l:x = <SID>rgb_number(a:r)
  let l:y = <SID>rgb_number(a:g)
  let l:z = <SID>rgb_number(a:b)

  if l:gx == l:gy && l:gy == l:gz
    " there are two possibilities
    let l:dgr = <SID>grey_level(l:gx) - a:r
    let l:dgg = <SID>grey_level(l:gy) - a:g
    let l:dgb = <SID>grey_level(l:gz) - a:b
    let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
    let l:dr = <SID>rgb_level(l:gx) - a:r
    let l:dg = <SID>rgb_level(l:gy) - a:g
    let l:db = <SID>rgb_level(l:gz) - a:b
    let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
    if l:dgrey < l:drgb
      " use the grey
      return <SID>grey_color(l:gx)
    else
      " use the color
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  else
    " only one possibility
    return <SID>rgb_color(l:x, l:y, l:z)
  endif
endfunction

" returns the palette index to approximate the '#rrggbb' hex string
function! <SID>rgb(rgb)
  let l:r = ("0x" . strpart(a:rgb, 1, 2)) + 0
  let l:g = ("0x" . strpart(a:rgb, 3, 2)) + 0
  let l:b = ("0x" . strpart(a:rgb, 5, 2)) + 0

  return <SID>color(l:r, l:g, l:b)
endfunction

function! <SID>HexHighlight()
  if !((&t_Co == 256) || has("gui_running"))
    echo "t_Co must be set to 256 or vim must be in gui mode."
    return
  endif

  if s:HexColored == 0
    let hexGroup = 0
    let lineNumber = 0
    while lineNumber <= line("$")
      let currentLine = getline(lineNumber)
      let hexLineMatch = 1
      while match(currentLine, '#\x\{6}', 0, hexLineMatch) != -1
        let hexMatch = matchstr(currentLine, '#\x\{6}', 0, hexLineMatch)
        if has("gui_running")
          execute 'hi HexColor' . hexGroup . ' guibg=' . hexMatch . ' guifg=White'
        else
          execute 'hi HexColor' . hexGroup . ' ctermbg=' . <SID>rgb(hexMatch) . ' ctermfg=White'
        endif
        execute 'call matchadd("HexColor' . hexGroup . '", "' . hexMatch .'")'
        let s:HexColors += ['HexColor' . hexGroup]
        let hexGroup += 1
        let hexLineMatch += 1
      endwhile
      let lineNumber += 1
    endwhile
    unlet lineNumber hexGroup
    let s:HexColored = 1
  elseif s:HexColored == 1
    for hexColor in s:HexColors
      exe 'highlight clear ' . hexColor
    endfor
    call clearmatches()
    let s:HexColored = 0
  endif
endfunction

map <Leader>hh :call <SID>HexHighlight()<CR>
