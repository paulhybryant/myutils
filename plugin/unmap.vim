" <leader>w= is mapped in Align.vim
" <leader>w is used by CamelCaseMotion for moving
" The mapping from Align make the motion slow because
" vim needs to wait for some time in case '=' is
" pressed after <leader>w. Is that a better way to
" avoid this?
unmap <leader>w=
