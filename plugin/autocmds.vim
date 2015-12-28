let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

augroup FileAu
  autocmd!
  autocmd BufRead *.log setlocal nospell
augroup END

autocmd BufEnter * call myutils#SyncNTTree()

if s:plugin.Flag('use_cmdwin')
  augroup CmdWin
    " musn't do au! again
    au CmdwinEnter * inoremap %% <C-r>=expand('#:h').'/'<CR>
    au CmdwinEnter * nnoremap <C-Q> :q<CR>

    au CmdwinLeave * nunmap <C-Q>
    au CmdwinLeave * iunmap %%
  augroup END
endif
