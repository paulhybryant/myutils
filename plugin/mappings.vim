let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Send the content in register with OCS52 control sequence.
vnoremap <C-c> y:call myutils#osc52#SendViaOSC52(getreg('"'))<CR>

" Use <C-Q> to close buffer window quickly.
inoremap <C-q> <ESC>:Bclose<cr>
nnoremap <C-q> :Bclose<cr>

" Disable key to enter ex mode
nnoremap Q <nop>

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" Quickly move in a line.
nnoremap H ^
nnoremap L $

" Concatenate two lines without whitespace at the end
nnoremap J gJ
nnoremap gJ J

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Use C-b to enter visual block mode from normal mode
nnoremap <C-b> <C-v>

" Use C-b to enter literal inputs in command mode
cnoremap <C-b> <C-v>
inoremap <C-b> <C-v>

" Use C-v to paste, this is needed in GVIM. In terminal vim this is handled by
" the terminal already. If not that will also be captured by this mapping.
if &clipboard == 'unnamedplus'
  inoremap <C-v> <C-r><C-o>+
else
  inoremap <C-v> <C-r><C-o>*
endif

" Ctrl-Tab only works in gvim
if has('gui_running')
    nnoremap <C-Tab> :bn<CR>
    nnoremap <C-S-Tab> :bp<CR>
else
    " The keycodes received by vim for <Tab> and <C-Tab> from most terminal
    " emulators are the same. So <Tab> is mapped here but one can also use
    " <C-Tab> to switch buffers. Same for <S-Tab>.
    nnoremap <Tab> :bn<CR>
    nnoremap <S-Tab> :bp<CR>
endif

" Paste from the yank register, which only gets overwriten by yanking but
" not deleting.
nnoremap <leader>pp "0p
vnoremap <leader>pp "0p

" Switch CWD to the directory of the open buffer
nnoremap <leader>cd :lcd %:p:h<CR>:pwd<CR>

" Print current file's full name (including path)
nnoremap <leader>fn :echo expand('%:p')<CR>

" Clear search register, stop highlighting current search text
nnoremap <silent> <leader>c/ :let @/=""<CR>

" Save the current window / tab
nnoremap <C-s> :w<cr>
inoremap <C-s> <ESC>:w<cr>

" Some helpers to edit mode http://vimcasts.org/e/14
cnoremap %% <C-r>=expand('%:h').'/'<CR>
" cabbr %% expand('%:p:h')

" For wrap text using textwidth when formatting text
nnoremap <leader>tw :setlocal formatoptions-=t<CR>

" Adjust viewports to the same size
nnoremap <leader>=w <C-w>=

" Write to files owned by root and is not opened with sudo
cnoremap w!! w !sudo tee > /dev/null %

" Improve completion popup menu
" http://vim.wikia.com/wiki/Improve_completion_popup_menu
" inoremap <expr> <Esc>      pumvisible() ? '\<C-e>' : '\<Esc>'
" inoremap <expr> <CR>       pumvisible() ? '\<C-y>' : '\<CR>'
inoremap <expr> <Down>     pumvisible() ? '\<C-n>' : '\<Down>'
inoremap <expr> <Up>       pumvisible() ? '\<C-p>' : '\<Up>'
inoremap <expr> <PageDown>
      \ pumvisible() ? '\<PageDown>\<C-p>\<C-n>' : '\<PageDown>'
inoremap <expr> <PageUp>
      \ pumvisible() ? '\<PageUp>\<C-p>\<C-n>' : '\<PageUp>'
inoremap <expr> <C-d> pumvisible() ? '\<PageDown>\<C-p>\<C-n>' : '\<C-d>'
inoremap <expr> <C-u> pumvisible() ? '\<PageUp>\<C-p>\<C-n>' : '\<C-u>'

" Identify the syntax highlighting group used at the cursor
nnoremap <F9> :echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name')
      \ . '> trans<'
      \ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
      \ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>

" Open all folds in the direct fold that contains current location
nnoremap zO [zzczO<C-O>

nnoremap <leader>hh :call myutils#HexHighlight()<CR>
nnoremap <leader>kb :call myutils#SetupTablineMappings(g:OS)<CR>
nnoremap <leader>ln :<C-u>execute 'call myutils#LocationNext()'<CR>
nnoremap <leader>lp :<C-u>execute 'call myutils#LocationPrevious()'<CR>
nnoremap <leader>tc :call myutils#ToggleColorColumn()<CR>
nnoremap <leader>is :call myutils#FillWithCharTillN(' ', 80)<CR>
noremap <leader>hl :call myutils#HighlightTooLongLines()<CR>
vmap <leader>y :call myutils#CopyText()<CR>
vnoremap <leader>sn :call myutils#SortWords(' ', 1)<CR>
vnoremap <leader>sw :call myutils#SortWords(' ', 0)<CR>
vnoremap <leader>wf1 :WIF 1 0<CR>
vnoremap <leader>wf2 :WIF 2 0<CR>
vnoremap <leader>wf3 :WIF 3 0<CR>
vnoremap <leader>wfi1 :WIF 1 1<CR>
vnoremap <leader>wfi2 :WIF 2 1<CR>
vnoremap <leader>wfi3 :WIF 3 1<CR>

" Vim keymappings to avoid pinky kuckle pain
" This is deprecated by swapping the ctrl and alt key using setxkbmap.
" nnoremap d 
" nnoremap u 
" nmap s 
" imap s 

" Unsed {{{
" Adding newline and stay in normal mode.
" <S-Enter> is not reflected, maybe captured by the tmux binding
" nnoremap <Enter> o<ESC>

" Replaced by tyru/operator-camelize
" Mapping for camelcase and underscore variable name conversion Change
" CamelCase to underscore (camel_case)
" noremap <leader>lc
      " \ viw:s#\C\(\u[a-z0-9]\+\\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g<CR>
" Change underscore to CamelCase, first letter not capitalized
" noremap <leader>lC viw:s#_\(\l\)#\u\1#g<CR>
" Change underscore to CamelCase, first letter also capitalized
" noremap <leader>ua viw:s#\(\%(\<\l\+\)\%(_\)\@=\)\\|_\(\l\)#\u\1\2#g<CR>
" cab lc s#\C\(\u[a-z0-9]\+\\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
" cab ua s#\(\%(\<\l\+\)\%(_\)\@=\)\\|_\(\l\)#\u\1\2#g

" Mapping for quoting a string, <leader>qi (quote it)
" noremap <leader>qi ciw"<C-r>""
" noremap <leader>qs ciw'<C-r>"'

" Make a simple 'search' text object
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
" http://vimcasts.org/episodes/operating-on-search-matches-using-gn/
" vnoremap <silent> t //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    " \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
" omap t :normal vt<CR>

" Automatically jump to end of text pasted
" vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]`

" <leader>w= is mapped in Align.vim
" <leader>w is used by CamelCaseMotion for moving
" The mapping from Align make the motion slow because vim needs to wait for
" some time in case '=' is pressed after <leader>w. Is that a better way to
" avoid this?
" silent! unmap <leader>w=
" silent! unmap <leader>m=
" }}}
