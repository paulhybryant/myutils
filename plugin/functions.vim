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
command! -nargs=* -complete=file -bang E call <SID>Edit("<bang>", <f-args>)
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
noremap <leader>hl :call <SID>HighlightTooLongLines()<CR>
" }}}


" Highlight columns from 81 - 120 to red {{{
function! <SID>ToggleColorColumn()
  if &colorcolumn
    let &colorcolumn = ""
  else
    let &colorcolumn = join(range(81,120), ',')
  endif
endfunction
nnoremap <leader>tc :call <SID>ToggleColorColumn()<CR>
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
command! Bclose call <SID>BufcloseCloseIt(1)
nnoremap <C-q> :Bclose<cr>
inoremap <C-q> <ESC>:Bclose<cr>
" }}}


" Call SQLUFormatter to format the sql statment, {{{
" and move the comma at the start of new line to end of previous line.
function! <SID>FormatSql()
  exec ':SQLUFormatter'
  exec ':%s/$\n\\(\\s*\\), /,\\r\\1'
endfunction

" Format SQL statements in the current buffer
command! Fsql call <SID>FormatSql()
" }}}


" Copy selected text to system clipboard {{{
" and prevent it from clearing clipboard when using ctrl+z (depends on xsel)
function! <SID>CopyText()
  normal gv"+y
  " call system('xsel -ib', getreg('+'))
  call system('echo "' . getreg('+') . '" | xsel -i')
endfunction

" Copy test to xsel
vmap <leader>y :call <SID>CopyText()<CR>
" }}}


" Map key to toggle options {{{
function! s:MapToggle(key, opt)
  let l:cmd = ':set ' . a:opt . '! \| set ' . a:opt . "?\<CR>"
  exec 'nnoremap ' . a:key . ' ' . l:cmd
  exec 'inoremap ' . a:key . " \<C-O>" . l:cmd
endfunction
command! -nargs=+ MapToggle call <SID>MapToggle(<f-args>)

" Display-altering option toggles
MapToggle <F1> spell
" }}}


" Insert repeated strings according to a pattern / template {{{
function! <SID>InsertRepeated(tmpl, lower, upper)
  let l:strs = split(a:tmpl, "%i", 1)
  for i in range(a:lower, a:upper)
    let l:str = join(l:strs, "" . i)
    put = l:str
  endfor
endfunction
command! -nargs=+ InsertRepeated call <SID>InsertRepeated(<f-args>)

" function! <SID>InsertRepeated2(tmpl, lower, upper)
  " put =map(range(a:lower, a:upper), 'printf(''%d'', v:val)')
" endfunction
" command! -nargs=+ InsertRepeated2 call <SID>InsertRepeated2(<f-args>)
" }}}


" functions for settping up tabline mappsing for different OSes {{{
function! <SID>SetupTablineMappingForMac()
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
nnoremap <leader>km :call <SID>SetupTablineMappingForMac()<CR>

function! <SID>SetupTablineMappingForLinux()
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
nnoremap <leader>kl :call <SID>SetupTablineMappingForLinux()<CR>

function! <SID>SetupTablineMappingForWindows()
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
nnoremap <leader>kw :call <SID>SetupTablineMappingForWindows()<CR>

if g:statusline_use_airline && exists('g:airline#extensions#tabline#buffer_idx_mode')
  if len($SSH_CLIENT) > 0
    if $SSH_OS == "Darwin"
      call <SID>SetupTablineMappingForMac()
    elseif $SSH_OS == "Linux"
      call <SID>SetupTablineMappingForLinux()
    endif
  else
    if OSX()
      call <SID>SetupTablineMappingForMac()
    elseif LINUX()
      call <SID>SetupTablineMappingForLinux()
    elseif WINDOWS()
      call <SID>SetupTablineMappingForWindows()
    endif
  endif
endif

" }}}

" Deprecated by vim-syncopate
" Define command HtmlExport for copying code with syntax highlight {{{
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

nnoremap <silent> <Plug>LocationPrevious :<C-u>exe 'call <SID>LocationPrevious()'<CR>
nnoremap <silent> <Plug>LocationNext :<C-u>exe 'call <SID>LocationNext()'<CR>
nmap <silent> <leader>lp <Plug>LocationPrevious
nmap <silent> <leader>ln <Plug>LocationNext
" }}}
