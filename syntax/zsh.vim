function! GetZshFold(lnum)
  if getline(a:lnum) =~# '\v^(function)?[^\(\)]*\(\) \{\s*#?.*$|.*\{\{\{$|^: \<\<\=cut$'
    return 'a1'
  elseif getline(a:lnum) =~# '\v^\}\s*#?.*$|.*\}\}\}$|^=cut$'
    return 's1'
  else
    return '='
  endif
endfunction

function! s:GetFileInfo(start)
  let l:lnum = a:start
  while l:lnum <= v:foldend
    let l:line = getline(l:lnum)
    if l:line =~# '\v^File:'
      return matchstr(l:line, '\vFile: \zs(.*)')
    endif
    let l:lnum += 1
  endwhile
  return 'Fix the comments!'
endfunction

function! s:GetFunctionInfo(start)
  let l:lnum = a:start
  let l:func = ''
  let l:numargs = 0
  let l:returns = ''
  while l:lnum <= v:foldend
    let l:line = getline(l:lnum)
    if l:line =~# '\v^\=item Function'
      let l:func = matchstr(l:line, '\v^\=item Function C\<\zs(.*)\ze\>$')
    elseif l:line =~# '\v^\$[0-9]'
      let l:numargs += 1
    elseif l:line =~# '\v^\@return'
      let l:returns = matchstr(l:line, '\v^\@return \zs(.*)\ze$')
    endif
    let l:lnum += 1
  endwhile
  if empty(l:func)
    return 'Fix the comments!'
  else
    for i in range(1, l:numargs)
      let l:func .= ' $' . i
    endfor
    return l:func . ' returns: ' . l:returns
  endif
endfunction

function! GetZshFoldText()
  let l:firstline = getline(v:foldstart)
  if l:firstline =~# '\v^: \<\<\=cut$'
    if v:foldend == line('$')
      " This is the POD end fold
      return ''
    endif
    let l:secondline = getline(v:foldstart + 1)
    if l:secondline =~# '\v^\=pod$'
      " This is the file level POD comments
      return s:GetFileInfo(v:foldstart + 2)
    else
      return s:GetFunctionInfo(v:foldstart + 1)
    endif
  endif
  return foldtext()
endfunction

setlocal foldmethod=expr
setlocal foldexpr=GetZshFold(v:lnum)
setlocal foldtext=GetZshFoldText()
