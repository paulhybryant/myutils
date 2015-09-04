function! GetZshFold(lnum)
  if getline(a:lnum) =~# '\v^function.*() \{$|.*\{\{\{'
    return 'a1'
  elseif getline(a:lnum) =~# '\v^\}$|.*\}\}\}'
    return 's1'
  else
    return '='
  endif
endfunction

setlocal foldmethod=expr
setlocal foldexpr=GetZshFold(v:lnum)
