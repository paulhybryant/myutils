let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Send the content in register with OCS52 control sequence.
vnoremap <unique> <C-c> y:call vimutils#osc52#SendViaOSC52(getreg('"'))<CR>

" Use <C-Q> to close buffer window quickly.
inoremap <unique> <silent> <C-q> <ESC>:Bclose<cr>
nnoremap <unique> <silent> <C-q> :Bclose<cr>

" Disable key to enter ex mode
nnoremap <unique> Q <nop>

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap <unique> j gj
nnoremap <unique> gj j
nnoremap <unique> k gk
nnoremap <unique> gk k

" Quickly move in a line.
nnoremap <unique> H ^
nnoremap <unique> L \|

" Concatenate two lines without whitespace at the end
nnoremap <unique> J gJ
nnoremap <unique> gJ J

" Visual shifting (does not exit Visual mode)
vnoremap <unique> < <gv
vnoremap <unique> > >gv

" Use C-b to enter visual block mode from normal mode
nnoremap <unique> <C-b> <C-v>

" Use C-b to enter literal inputs in command mode
" Override the mapping from vim-rsi
cnoremap <C-b> <C-v>
inoremap <C-b> <C-v>

" Use C-v to paste, this is needed in GVIM. In terminal vim this is handled by
" the terminal already. If not that will also be captured by this mapping.
if &clipboard == 'unnamedplus'
  inoremap <unique> <C-v> <C-r><C-o>+
else
  inoremap <unique> <C-v> <C-r><C-o>*
endif

" Ctrl-Tab only works in gvim
if has('gui_running')
    nnoremap <unique> <C-Tab> :bn<CR>
    nnoremap <unique> <C-S-Tab> :bp<CR>
else
    " The keycodes received by vim for <Tab> and <C-Tab> from most terminal
    " emulators are the same. So <Tab> is mapped here but one can also use
    " <C-Tab> to switch buffers. Same for <S-Tab>.
    nnoremap <unique> <Tab> :bn<CR>
    nnoremap <unique> <S-Tab> :bp<CR>
endif

" Paste from the yank register, which only gets overwriten by yanking but
" not deleting.
nnoremap <unique> <leader>p "0p
vnoremap <unique> <leader>p "0p

" Switch CWD to the directory of the open buffer
nnoremap <unique> <leader>cd :lcd %:p:h<CR>:pwd<CR>

" Print current file's full name (including path)
nnoremap <unique> <leader>fn :echo expand('%:p')<CR>

" Clear search register, stop highlighting current search text
nnoremap <unique> <silent> <leader>c/ :let @/=""<CR>

" Save the current window / tab
nnoremap <unique> <C-s> :w<cr>
" Conflicts with vim-surround
inoremap <C-s> <ESC>:w<cr>

" Some helpers to edit mode http://vimcasts.org/e/14
cnoremap <unique> %% <C-r>=expand('%:h').'/'<CR>
" cabbr %% expand('%:p:h')

" For wrap text using textwidth when formatting text
nnoremap <unique> <leader>tw :setlocal formatoptions-=t<CR>

" Adjust viewports to the same size
nnoremap <unique> <leader>=w <C-w>=

" Write to files owned by root and is not opened with sudo
cnoremap <unique> w!! w !sudo tee > /dev/null %

" Improve completion popup menu
" http://vim.wikia.com/wiki/Improve_completion_popup_menu
" inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
" inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <unique> <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <unique> <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <unique> <expr> <PageDown>
      \ pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <unique> <expr> <PageUp>
      \ pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
inoremap <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <unique> <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" Identify the syntax highlighting group used at the cursor
nnoremap <unique> <F9> :echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name')
      \ . '> trans<'
      \ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
      \ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>

" Open all folds in the direct fold that contains current location
nnoremap <unique> zO [zzczO<C-O>

nnoremap <unique> <leader>he :call vimutils#HexHighlight()<CR>
nnoremap <unique> <leader>ln :<C-u>execute 'call vimutils#LocationNext()'<CR>
nnoremap <unique> <leader>lp :<C-u>execute 'call vimutils#LocationPrevious()'<CR>
nnoremap <unique> <leader>tc :call vimutils#ToggleColorColumn()<CR>
nnoremap <unique> <leader>is :call vimutils#FillWithCharTillN(' ', 80)<CR>
nnoremap <unique> <leader>hl :call vimutils#HighlightTooLongLines()<CR>
" vnoremap <unique> <silent> y y:call vimutils#CopyText()<CR>
" copy the current text selection to the system clipboard
if has('gui_running') || has('nvim') && exists('$DISPLAY')
  noremap <Leader>y "+y
else
  " copy to attached terminal using the yank(1) script:
  " https://github.com/sunaku/home/blob/master/bin/yank
  noremap <silent> <Leader>y y:call system('yank > /dev/tty', @0)<Return>
endif
nnoremap <unique> yy Vy
vnoremap <unique> <leader>sn :call vimutils#SortWords(' ', 1)<CR>
vnoremap <unique> <leader>sw :call vimutils#SortWords(' ', 0)<CR>
vnoremap <unique> <leader>wf1 :WIF 1 0<CR>
vnoremap <unique> <leader>wf2 :WIF 2 0<CR>
vnoremap <unique> <leader>wf3 :WIF 3 0<CR>
vnoremap <unique> <leader>wfi1 :WIF 1 1<CR>
vnoremap <unique> <leader>wfi2 :WIF 2 1<CR>
vnoremap <unique> <leader>wfi3 :WIF 3 1<CR>

nnoremap <unique> <leader>rf :<C-U>RangerChooser<CR>

if s:plugin.Flag('use_cmdwin')
  nnoremap <unique> : q:i
endif

" Automatically jump to end of text pasted
vnoremap <unique> <silent> Y y`]
vnoremap <unique> <silent> P p`]
nnoremap <unique> <silent> P p`]`

" Note that not all terminal sends this escape code for <C-Up> In fact most
" terminals probably won't send anything different than <Up> For iterm2, one can
" config this in the terminal preference. For other terminals, this should work
" with .inputrc (may not)? If yes, for shells using readline.  For zsh which has
" its own line editor, this can be configured using zsh's bindkey builtin.
map [1;5A <C-Up>
map [1;5A <C-Down>
noremap <unique> <silent> <C-Up> :res +5<CR>
noremap <unique> <silent> <C-Down> :res -5<CR>

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

" Make a simple 'search' text object
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
" http://vimcasts.org/episodes/operating-on-search-matches-using-gn/
" vnoremap <silent> t //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    " \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
" omap t :normal vt<CR>

" }}}
