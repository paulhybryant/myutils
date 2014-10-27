" Disable key to enter ex mode
nnoremap Q <nop>

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" Concatenate two lines without whitespace at the end
noremap J gJ
noremap gJ J

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Use C-b to enter visual block mode from normal mode
nnoremap <C-b> <C-v>

" Use C-b to enter literal inputs in command mode
cnoremap <C-b> <C-v>
inoremap <C-b> <C-v>

" Ctrl-Tab only works in gvim
if has('gui_running')
    nnoremap <C-Tab> :bn<CR>
    nnoremap <C-S-Tab> :bp<CR>
else
    " The keycodes received by vim for <Tab> and <C-Tab> from most
    " terminal emulators are the same. So <Tab> is mapped here but one can
    " also use <C-Tab> to switch buffers. Same for <S-Tab>.
    nnoremap <Tab> :bn<CR>
    nnoremap <S-Tab> :bp<CR>
    " nnoremap <C-PageDown> :bn<CR>
    " nnoremap <C-PageUp> :bp<CR>
endif

" Paste from the yank register, which only gets overwriten by yanking but
" not deleting.
nnoremap <leader>p "0p

" Switch CWD to the directory of the open buffer
noremap <leader>cd :lcd %:p:h<cr>:pwd<CR>

" Print current file's full name (including path)
noremap <leader>fn :echo expand('%:p')<CR>

" Mapping for quoting a string, <leader>qi (quote it)
" Not working well with words having 1 character
" noremap <leader>qi bi"<ESC>lviw<ESC>a"<ESC>
" Replaced by vim-surround
" noremap <leader>qi ciw"<C-r>""
" noremap <leader>qs ciw'<C-r>"'

" Write to files owned by root and is not opened with sudo
cmap w!! w !sudo tee > /dev/null %

" Mapping for camelcase and underscore variable name conversion
" Change CamelCase to underscore (camel_case)
noremap <leader>lc viw:s#\C\(\u[a-z0-9]\+\\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g<CR>
" Change underscore to CamelCase, first letter not capitalized
noremap <leader>uu viw:s#_\(\l\)#\u\1#g<CR>
" Change underscore to CamelCase, first letter also capitalized
noremap <leader>ua viw:s#\(\%(\<\l\+\)\%(_\)\@=\)\\|_\(\l\)#\u\1\2#g<CR>
" cab lc s#\C\(\u[a-z0-9]\+\\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
" cab ua s#\(\%(\<\l\+\)\%(_\)\@=\)\\|_\(\l\)#\u\1\2#g

" Clear search register, stop highlighting current search text
nnoremap <silent> <leader>c/ :let @/=""<CR>

" Save the current window / tab
nnoremap <c-s> :w<cr>
inoremap <c-s> <ESC>:w<cr>

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<CR>
" cabbr %% expand('%:p:h')

" Toggle spell
nnoremap <leader>ts :let &spell = !&spell<CR>

" Toggle paste
nnoremap <leader>tp :let &paste = !&paste<CR>

" For wrap text using textwidth when formatting text
nnoremap <leader>tw :setlocal formatoptions-=t<CR>

" Adjust viewports to the same size
map <leader>=w <C-w>=

" Make a simple 'search' text object
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
" http://vimcasts.org/episodes/operating-on-search-matches-using-gn/
vnoremap <silent> t //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap t :normal vt<CR>

" Automatically jump to end of text pasted
" vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]`

" Adding newline and stay in normal mode.
" <S-Enter> is not reflected, maybe captured by the tmux binding
nnoremap <Enter> o<ESC>

" <leader>w= is mapped in Align.vim
" <leader>w is used by CamelCaseMotion for moving
" The mapping from Align make the motion slow because vim needs to wait for some
" time in case '=' is pressed after <leader>w. Is that a better way to avoid
" this?
silent! unmap <leader>w=
silent! unmap <leader>m=

" Improve completion popup menu
" http://vim.wikia.com/wiki/Improve_completion_popup_menu
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
inoremap <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" Unused, use vim-airline for fast buffer switching instead
" Switch tabs by press alt + tabid
" NORMAL mode bindings for vim(terminal mode)
" These mappings will be useful if you start vim with vim -p and also enable the
" following autocommand
" Open all new buffer in a new tab
" autocmd BufAdd,BufNewFile * nested tab sball
" noremap 1 1gt
" noremap 2 2gt
" noremap 3 3gt
" noremap 4 4gt
" noremap 5 5gt
" noremap 6 6gt
" noremap 7 7gt
" noremap 8 8gt
" noremap 9 9gt
