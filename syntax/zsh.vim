function! GetZshFold(lnum)
  if getline(a:lnum) =~# '\v^(function)?[^\(\)]*\(\) \{\s*#?.*$|.*\{\{\{'
    return 'a1'
  elseif getline(a:lnum) =~# '\v^\}\s*#?.*$|.*\}\}\}'
    return 's1'
  else
    return '='
  endif
endfunction

setlocal foldmethod=expr
setlocal foldexpr=GetZshFold(v:lnum)
