function! airline#extensions#tabline#formatters#customtab#format(bufnr, buffers)
  return fnamemodify(bufname(a:bufnr), ':p')
endfunction
