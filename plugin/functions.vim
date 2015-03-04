" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:
" Allow using command :E to edit multiple files {{{
" Only files (not directories) matched by the glob pattern will be edited
function! s:Edit(really, ...)
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
command! -nargs=* -complete=file -bang E call s:Edit("<bang>", <f-args>)
" }}}

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

" Confirm saving buffers before it is closed. {{{
" Quit vim if the closed buffer is the last buffer
function! s:BufcloseCloseIt(confirm)
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

" Close the current and window / tab
command! Bclose call s:BufcloseCloseIt(1)
nnoremap <C-q> :Bclose<cr>
inoremap <C-q> <ESC>:Bclose<cr>
" }}}

" Call SQLUFormatter to format the sql statment, {{{
" and move the comma at the start of new line to end of previous line.
function! s:FormatSql()
  exec ':SQLUFormatter'
  exec ':%s/$\n\\(\\s*\\), /,\\r\\1'
endfunction

" Format SQL statements in the current buffer
command! Fsql call s:FormatSql()
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

" Map key to toggle options {{{
function! s:MapToggle(key, opt)
  let l:cmd = ':set ' . a:opt . '! \| set ' . a:opt . "?\<CR>"
  exec 'nnoremap ' . a:key . ' ' . l:cmd
  exec 'inoremap ' . a:key . " \<C-O>" . l:cmd
endfunction
command! -nargs=+ MapToggle call s:MapToggle(<f-args>)

" Display-altering option toggles
MapToggle <F1> spell
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

" Define command HtmlExport for copying code with syntax highlight {{{
" Deprecated by vim-syncopate
" function! s:HtmlExport(keep_colorscheme) range
  " let l:has_number = &number
  " if (!a:keep_colorscheme)
    " let l:old_colorscheme = get(g:, 'colors_name', 'default')
    " colorscheme default
    " if l:has_number
      " set nonumber
    " endif
  " endif
  " execute a:firstline . ',' . a:lastline 'TOhtml'
  " w
  " let l:html_file = @%
  " call system(printf("cp '%s' /tmp/vimout.html; sensible-browser /tmp/vimout.html || open /tmp/vimout.html", l:html_file))
  " bwipeout
  " call system(printf("rm '%s'", l:html_file))
  " if (!a:keep_colorscheme)
    " execute 'colorscheme' l:old_colorscheme
    " if l:has_number
      " set number
    " endif
  " endif
" endfunction
" noremap <silent> <Leader><> :HtmlExport<CR>
" ounmap <Leader><>
" command! -bang -nargs=0 -range=% HtmlExport
  " \ <line1>,<line2>call s:HtmlExport('<bang>' ==# '!')
" }}}

" Wrapper for Decho to echo debug information from a command execution {{{
function! s:DechoCmd(cmd)
  redir => l:msg
  silent execute a:cmd
  redir END
  silent execute "Decho '" . l:msg . "'"
endfunction
command! -nargs=+ -complete=command DC call s:DechoCmd(<q-args>)
" }}"

" Enable jumping using location list when only one error exists {{{
function! s:LocationPrevious()
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfunction

function! s:LocationNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfunction

nnoremap <silent> <Plug>LocationPrevious :<C-u>exe 'call s:LocationPrevious()'<CR>
nnoremap <silent> <Plug>LocationNext :<C-u>exe 'call s:LocationNext()'<CR>
nmap <silent> <leader>lp <Plug>LocationPrevious
nmap <silent> <leader>ln <Plug>LocationNext
" }}}

" Remove trailing whitespaces and ^M chars {{{
function! s:ToggleStripingTrailingWhitespace()
  if !exists('g:keep_trailing_whitespace') || g:keep_trailing_whitespace == 0
    let g:keep_trailing_whitespace = 1
  else
    let g:keep_trailing_whitespace = 0
  endif
endfunction
nnoremap <leader>tws :call s:ToggleStripingTrailingWhitespace()<CR>

" autocmd FileType * autocmd BufWritePre <buffer> call s:StripTrailingWhitespace()
function! s:StripTrailingWhitespace()
  if !exists('g:keep_trailing_whitespace') || g:keep_trailing_whitespace == 0
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endif
endfunction
" }}}
