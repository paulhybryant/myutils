let b:zsh_fold_level = 0
function! GetZshFold(lnum)
  if a:lunm == 1
    let b:zsh_fold_level = 0
  endif
  if getline(a:lnum) =~# '\v^function.*() \{$|.*\{\{\{'
    let b:zsh_fold_level += 1
    let l:level = '>'.b:zsh_fold_level
  elseif getline(a:lnum) =~# '\v^\}$|.*\}\}\}'
    let l:level = '<'.b:zsh_fold_level
    let b:zsh_fold_level -= 1
  else
    let l:level = ''.b:zsh_fold_level
  endif
  return l:level
endfunction

setlocal foldmethod=expr
setlocal foldexpr=GetZshFold(v:lnum)
