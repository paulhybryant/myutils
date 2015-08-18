" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Get the array of normal buffers, by normal it means it is not special buffer
" that is for exampe hidden
function! myutils#GetListedBuffers()  " {{{
    return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction
" }}}

" Get the number of normal listed buffers, by normal it means it is not
" special buffers that are for exampe hidden
function! myutils#GetNumListedBuffers() " {{{
    return len(myutils#GetListedBuffers())
endfunction
" }}}

" Get the next number of normal buffers after 'cur_bufnr'. The next number is
" the smallest buffer number that is larger than 'cur_bufnr'. If 'cur_bufnr'
" is the largest buffer number, return the largest buffer number that is
" smaller than 'cur_bufnr'. Returns 'cur_bufnr' if there is only one normal
" buffer.
function! myutils#NextBufNr(cur_bufnr) " {{{
    let l:buffers = myutils#GetListedBuffers()

    if &buftype == 'quickfix' || &buftype == 'indicator'
        return -1
    endif

    " for var in g:myutils#special_bufvars
        " if exists('b:' . var)
            " return -1
        " endif
    " endfor

    if len(l:buffers) == 1
        if l:buffers[0] == a:cur_bufnr
            return l:buffers[0]
        else
            return -1
        endif
    endif

    for i in range(0, len(l:buffers) - 1)
        if l:buffers[i] == a:cur_bufnr
            if i == len(l:buffers) - 1
                return l:buffers[i - 1]
            else
                return l:buffers[i + 1]
            endif
        endif
    endfor
    return -1
endfunction
" }}}

" Whether the current window is the NERDTree window
function! myutils#IsInNERDTreeWindow() " {{{
  return exists("b:NERDTreeType")
endfunction
" }}}

" Returns true iff is NERDTree open/active
function! myutils#IsNTOpen() " {{{
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction
" }}}

" Calls NERDTreeFind iff NERDTree is active, current window contains a
" modifiable file, and we're not in vimdiff
function! myutils#SyncNTTree() " {{{
    if &modifiable && myutils#IsNTOpen() && strlen(expand('%')) > 0 && !&diff
        if !exists('t:NERDTreeBufName') || bufname('%') != t:NERDTreeBufName
            NERDTreeFind
            wincmd p
        endif
    endif
endfunction
" }}}

" Sort words selected in visual mode in a single line, separated by space
function! myutils#SortWords(delimiter, numeric) range " {{{
    let l:delimiter = a:delimiter
    if a:firstline != a:lastline
        echomsg "Can only sort words in a single line."
    endif
    if len(l:delimiter) != 1
        let l:delimiter = ' '
    endif
    " yank current visual selection to reg x
    normal gv"xy
    " split the words selected and sort
    if a:numeric
        let @x = join(sort(map(split(@x, l:delimiter), 'str2nr(v:val)'), 'n'), l:delimiter)
    else
        let @x = join(sort(split(@x, l:delimiter)), l:delimiter)
    endif
    " re-select area and delete
    normal gvd
    " paste sorted words back in
    normal "xP
endfunction
" }}}

" Get the total number of normal windows
function! myutils#GetNumberOfNormalWindows() " {{{
    return len(filter(range(1, winnr('$')), 'buflisted(winbufnr(v:val))'))
endfunction
" }}}

" Functions for editing related files
function! myutils#EditHeader() " {{{
  let l:filename = expand("%")
  if l:filename =~# ".*\.h$"
    return
  elseif l:filename =~# ".*_unittest\.cc$"
    let l:filename = substitute(l:filename, "\\v(.*)_unittest\.cc", "\\1", "")
  elseif l:filename =~# ".*\.cc$"
    let l:filename = substitute(l:filename, "\\v(.*)\.cc", "\\1", "")
  endif
  exec "edit " . fnameescape(l:filename . ".h")
endfunction

function! myutils#EditCC()
  let l:filename = expand("%")
  if l:filename =~# ".*_unittest\.cc"
    let l:filename = substitute(l:filename, "\\v(.*)_unittest\.cc", "\\1", "")
  elseif l:filename =~# ".*\.h"
    let l:filename = substitute(l:filename, "\\v(.*)\.h", "\\1", "")
  else
    return
  endif
  exec "edit " . fnameescape(l:filename . ".cc")
endfunction

function! myutils#EditTest()
  let l:filename = expand("%")
  if l:filename =~# ".*_unittest\.cc"
    return
  elseif l:filename =~# ".*\.cc"
    let l:filename = substitute(l:filename, "\\v(.*)\.cc", "\\1", "")
  elseif l:filename =~# ".*\.h"
    let l:filename = substitute(l:filename, "\\v(.*)\.h", "\\1", "")
  endif
  exec "edit " . fnameescape(l:filename . "_unittest.cc")
endfunction
" }}}

" Functions for settping up tabline mappsing for different OSes
function! myutils#SetupTablineMappingForMac() " {{{
  silent! nmap <silent> <unique> ¡ <Plug>AirlineSelectTab1
  silent! nmap <silent> <unique> ™ <Plug>AirlineSelectTab2
  silent! nmap <silent> <unique> £ <Plug>AirlineSelectTab3
  silent! nmap <silent> <unique> ¢ <Plug>AirlineSelectTab4
  silent! nmap <silent> <unique> ∞ <Plug>AirlineSelectTab5
  silent! nmap <silent> <unique> § <Plug>AirlineSelectTab6
  silent! nmap <silent> <unique> ¶ <Plug>AirlineSelectTab7
  silent! nmap <silent> <unique> • <Plug>AirlineSelectTab8
  silent! nmap <silent> <unique> ª <Plug>AirlineSelectTab9
endfunction

function! myutils#SetupTablineMappingForLinux()
  if has('gui_running')
    silent! nmap <silent> <unique> <M-1> <Plug>AirlineSelectTab1
    silent! nmap <silent> <unique> <M-2> <Plug>AirlineSelectTab2
    silent! nmap <silent> <unique> <M-3> <Plug>AirlineSelectTab3
    silent! nmap <silent> <unique> <M-4> <Plug>AirlineSelectTab4
    silent! nmap <silent> <unique> <M-5> <Plug>AirlineSelectTab5
    silent! nmap <silent> <unique> <M-6> <Plug>AirlineSelectTab6
    silent! nmap <silent> <unique> <M-7> <Plug>AirlineSelectTab7
    silent! nmap <silent> <unique> <M-8> <Plug>AirlineSelectTab8
    silent! nmap <silent> <unique> <M-9> <Plug>AirlineSelectTab9
  else
    silent! nmap <silent> <unique> 1 <Plug>AirlineSelectTab1
    silent! nmap <silent> <unique> 2 <Plug>AirlineSelectTab2
    silent! nmap <silent> <unique> 3 <Plug>AirlineSelectTab3
    silent! nmap <silent> <unique> 4 <Plug>AirlineSelectTab4
    silent! nmap <silent> <unique> 5 <Plug>AirlineSelectTab5
    silent! nmap <silent> <unique> 6 <Plug>AirlineSelectTab6
    silent! nmap <silent> <unique> 7 <Plug>AirlineSelectTab7
    silent! nmap <silent> <unique> 8 <Plug>AirlineSelectTab8
    silent! nmap <silent> <unique> 9 <Plug>AirlineSelectTab9
  endif
endfunction

function! myutils#SetupTablineMappingForWindows()
  silent! nmap <silent> <unique> ± <Plug>AirlineSelectTab1
  silent! nmap <silent> <unique> ² <Plug>AirlineSelectTab2
  silent! nmap <silent> <unique> ³ <Plug>AirlineSelectTab3
  silent! nmap <silent> <unique> ´ <Plug>AirlineSelectTab4
  silent! nmap <silent> <unique> µ <Plug>AirlineSelectTab5
  silent! nmap <silent> <unique> ¶ <Plug>AirlineSelectTab6
  silent! nmap <silent> <unique> · <Plug>AirlineSelectTab7
  silent! nmap <silent> <unique> ¸ <Plug>AirlineSelectTab8
  silent! nmap <silent> <unique> ¹ <Plug>AirlineSelectTab9
endfunction
" }}}

" Remove trailing whitespaces and ^M chars
function! myutils#StripTrailingWhitespace() " {{{
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" }}}

" Allow using command :E to edit multiple files
" Only files (not directories) matched by the glob pattern will be edited
function! myutils#MultiEdit(really, ...) " {{{
  if len(a:000)
    for globspec in a:000
      let l:files = split(glob(globspec), "\n")
      for fname in l:files
        if !isdirectory(fname)
          exec 'e'.(a:really).' '.(fname)
        endif
      endfor
    endfor
  else
    exec 'e'.(a:really)
  endif
endfunction
" }}}

" Highlight hex strings with the color the hex string represents {{{
let s:HexColored = 0
let s:HexColors = []

" Returns an approximate grey index for the given grey level
function! s:grey_number(x) " {{{
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
" }}}

" Returns the actual grey level represented by the grey index
function! s:grey_level(n) " {{{
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
" }}}

" Returns the palette index for the given grey index
function! s:grey_color(n) " {{{
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
" }}}

" Returns an approximate color index for the given color level
function! s:rgb_number(x) " {{{
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
" }}}

" Returns the actual color level for the given color index
function! s:rgb_level(n) " {{{
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
" }}}

" Returns the palette index for the given R/G/B color indices
function! s:rgb_color(x, y, z) " {{{
  if &t_Co == 88
    return 16 + (a:x * 16) + (a:y * 4) + a:z
  else
    return 16 + (a:x * 36) + (a:y * 6) + a:z
  endif
endfunction
" }}}

" Returns the palette index to approximate the given R/G/B color levels
function! s:color(r, g, b) " {{{
  " get the closest grey
  let l:gx = s:grey_number(a:r)
  let l:gy = s:grey_number(a:g)
  let l:gz = s:grey_number(a:b)

  " get the closest color
  let l:x = s:rgb_number(a:r)
  let l:y = s:rgb_number(a:g)
  let l:z = s:rgb_number(a:b)

  if l:gx == l:gy && l:gy == l:gz
    " there are two possibilities
    let l:dgr = s:grey_level(l:gx) - a:r
    let l:dgg = s:grey_level(l:gy) - a:g
    let l:dgb = s:grey_level(l:gz) - a:b
    let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
    let l:dr = s:rgb_level(l:gx) - a:r
    let l:dg = s:rgb_level(l:gy) - a:g
    let l:db = s:rgb_level(l:gz) - a:b
    let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
    if l:dgrey < l:drgb
      " use the grey
      return s:grey_color(l:gx)
    else
      " use the color
      return s:rgb_color(l:x, l:y, l:z)
    endif
  else
    " only one possibility
    return s:rgb_color(l:x, l:y, l:z)
  endif
endfunction
" }}}

" Returns the palette index to approximate the '#rrggbb' hex string
function! s:rgb(rgb) " {{{
  let l:r = ("0x" . strpart(a:rgb, 1, 2)) + 0
  let l:g = ("0x" . strpart(a:rgb, 3, 2)) + 0
  let l:b = ("0x" . strpart(a:rgb, 5, 2)) + 0

  return s:color(l:r, l:g, l:b)
endfunction
" }}}

" Highlight the hex string
function! myutils#HexHighlight() " {{{
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
          execute 'hi HexColor' . hexGroup . ' ctermbg=' . s:rgb(hexMatch) . ' ctermfg=White'
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
" }}}
" }}}

" Wrapper for Decho to echo debug information from a command execution
function! myutils#DechoCmd(cmd) " {{{
  redir => l:msg
  silent execute a:cmd
  redir END
  silent execute "Decho '" . l:msg . "'"
endfunction
" }}}

" Enable jumping using location list when only one error exists
function! myutils#LocationPrevious() " {{{
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfunction

function! myutils#LocationNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfunction
" }}}

" Insert charater char from current position until the cursor reaches column n
function! myutils#FillWithCharTillN(char, n) " {{{
  let l:col = getpos('.')[2]
  if l:col >= a:n
    return
  endif

  let l:num_chars = a:n - l:col
  if (strlen(getline('.')) == 0)
    let l:num_chars += 1
  endif
  exec "normal a" . repeat(a:char, l:num_chars)
endfunction
" }}}

" Map key to toggle options
function! myutils#MapToggle(key, opt) "  {{{
  let l:cmd = ':set ' . a:opt . '! \| set ' . a:opt . "?\<CR>"
  exec 'nnoremap ' . a:key . ' ' . l:cmd
  exec 'inoremap ' . a:key . " \<C-O>" . l:cmd
endfunction
" }}}

" Map key to toggle global variable. Value 1 will be assigned if original
" value is 0.
function! myutils#MapToggleVar(key, var) " {{{
  execute 'nnoremap ' . a:key . ' :call myutils#ToggleVar(' . a:var . ')<CR>'
endfunction

function! myutils#ToggleVar(var)
  execute "let l:varval=g:" . a:var
  if l:varval > 0
    let l:varval = 0
  else
    let l:varval = 1
  endif
  execute "let g:" . a:var . "=l:varval"
endfunction
" }}}

" Call SQLUFormatter to format the sql statment, and move the comma at the
" start of new line to end of previous line.
function! myutils#FormatSql() "  {{{
  " Can also use !neobundle#is_sourced('SQLUtilities')
  if !exists(":SQLUFormatter")
    echoerr "Bundle SQLUtilities not loaded"
  endif
  exec ':SQLUFormatter'
  exec ':%s/$\n\\(\\s*\\), /,\\r\\1'
endfunction
" }}}

" Confirm saving buffers before it is closed and quit vim if the closed buffer
" is the last buffer.
function! myutils#BufcloseCloseIt(confirm) " {{{
  if myutils#IsInNERDTreeWindow()
    NERDTreeToggle
    return
  endif

  if &mod && a:confirm
    if input("Save changes?(y/n) ") == "y"
      execute("w!")
    endif
  endif

  let l:currentBufNum = bufnr("%")
  let l:next_bufnr = myutils#NextBufNr(l:currentBufNum)
  if l:next_bufnr == -1
    " Current buffer is a special buffer (help, NERDTree, etc)
    execute("bdelete! ".l:currentBufNum)
  elseif l:next_bufnr == l:currentBufNum
    " Current buffer is the only listed buffer
    execute("qa!")
  else
    if myutils#GetNumberOfNormalWindows() == 1
      execute("b! " . l:next_bufnr)
      execute("bdelete! ".l:currentBufNum)
    else
      execute "wincmd q"
    endif
    " execute("bwipeout! ".l:currentBufNum)
  endif
endfunction
" }}}

" Highlight columns that is larger than textwidth
function! myutils#HighlightTooLongLines() "  {{{
  if !exists('g:htll') || g:htll == 0
    let g:htll = 1
    highlight def link RightMargin Error
    sign define errlongline text=>> texthl=ErrorMsg
    if &textwidth != 0
      let g:htllm = matchadd('ErrorMsg', '\%>' . &l:textwidth . 'v.\+', -1)
    endif
  else
    let g:htll = 0
    if (exists('g:htllm'))
      call matchdelete(g:htllm)
    endif
  endif
endfunction
" }}}

" Highlight columns from 81 - 120 to red
function! myutils#ToggleColorColumn() "  {{{
  if &colorcolumn
    let &colorcolumn = ""
  else
    let &colorcolumn = join(range(81,120), ',')
  endif
endfunction
" }}}

" Copy selected text to system clipboard and prevent it from clearing
" clipboard when using ctrl+z (depends on xsel)
function! myutils#CopyText() "  {{{

  normal gv"+y
  " call system('xsel -ib', getreg('+'))
  call system('echo "' . getreg('+') . '" | xsel -i')
endfunction
" }}}

" Insert repeated strings according to a pattern / template
function! myutils#InsertRepeated(tmpl, lower, upper) " {{{
  let l:strs = split(a:tmpl, "%i", 1)
  for i in range(a:lower, a:upper)
    let l:str = join(l:strs, "" . i)
    put = l:str
  endfor
endfunction

" function! myutils#InsertRepeated(tmpl, lower, upper)
  " put =map(range(a:lower, a:upper), 'printf(''%d'', v:val)')
" endfunction
" }}}

" Test whether a specific syntax group exists
function! myutils#SyntaxGroupExists(group_name) " {{{
  let l:syntaxes=""
  redir => l:syntaxes
  silent syntax
  redir END
  return stridx(l:syntaxes, a:group_name) > 0
endfunction
" }}}

" Get the definition of a syntax group
function! myutils#GetSynGroup(group_name) " {{{
  let l:syngroup=""
  redir => l:syngroup
  execute "silent! syntax list " . a:group_name
  redir END
  let l:groups = split(l:syngroup, "\n")
  if len(l:groups) != 2
    return ""
  endif
  return maktaba#string#Strip(l:groups[1])
endfunction
" }}}

" Yank the contents in register * to remote clipboard This function should be
" used together with clipper https://github.com/wincent/clipper
" Clipper should be started at the remote host to copy the contents to. It
" creates a daemon listening at port 8377 at the remote host. For SSH remote
" port forwarding is needed. 'ssh -R 8377:localhost:8377 host_ip'. Or config
" 'RemoteForward 8377 localhost:8377' in '~/.ssh/config'. This is only tested in
" Mac OSX. If the remote host is linux, consider using xclip and x forwarding.
" Couldn't get x forwarding and xclip to work in Mac OSX, and ubuntu remote host
" is not tried.
function! myutils#YankToRemoteClipboard() " {{{
  let l:reg = getreg("*")
  " let l:reg = substitute(l:reg, "'", "\\\\'", "g")
  " let l:reg = substitute(l:reg, "\x0a", "", "")
  let l:cmd = printf("echo -n '%s' \| nc localhost 8377", l:reg)
  call system(l:cmd)
endfunction
" }}}

" Find the window among all windows that with w:id equals to wid
function! myutils#FindWindowWithId(wid) " {{{
  for tabnr in range(1, tabpagenr('$'))
    for winnr in range(1, tabpagewinnr(tabnr, '$'))
      if gettabwinvar(tabnr, winnr, 'id') is a:wid
        return [tabnr, winnr]
      endif
    endfor
  endfor
  return [0, 0]
endfunction
" }}}
