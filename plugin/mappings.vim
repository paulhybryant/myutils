let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Send the content in register with OCS52 control sequence.
vmap <C-c> y:call myutils#osc52#SendViaOSC52(getreg('"'))<CR>

" Use <C-Q> to close buffer window quickly.
inoremap <C-q> <ESC>:Bclose<cr>
nnoremap <C-q> :Bclose<cr>
