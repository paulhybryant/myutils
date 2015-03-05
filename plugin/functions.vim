" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Highlight columns that is larger than textwidth {{{
function! s:HighlightTooLongLines()
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
noremap <leader>hl :call s:HighlightTooLongLines()<CR>
" }}}

" Highlight columns from 81 - 120 to red {{{
function! s:ToggleColorColumn()
  if &colorcolumn
    let &colorcolumn = ""
  else
    let &colorcolumn = join(range(81,120), ',')
  endif
endfunction
nnoremap <leader>tc :call s:ToggleColorColumn()<CR>
" }}}

" Copy selected text to system clipboard {{{
" and prevent it from clearing clipboard when using ctrl+z (depends on xsel)
function! s:CopyText()
  normal gv"+y
  " call system('xsel -ib', getreg('+'))
  call system('echo "' . getreg('+') . '" | xsel -i')
endfunction

" Copy test to xsel
vmap <leader>y :call s:CopyText()<CR>
" }}}

" Insert repeated strings according to a pattern / template {{{
function! s:InsertRepeated(tmpl, lower, upper)
  let l:strs = split(a:tmpl, "%i", 1)
  for i in range(a:lower, a:upper)
    let l:str = join(l:strs, "" . i)
    put = l:str
  endfor
endfunction
command! -nargs=+ InsertRepeated call s:InsertRepeated(<f-args>)

" function! s:InsertRepeated2(tmpl, lower, upper)
  " put =map(range(a:lower, a:upper), 'printf(''%d'', v:val)')
" endfunction
" command! -nargs=+ InsertRepeated2 call s:InsertRepeated2(<f-args>)
" }}}
