let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

augroup FiletypeFormat
  autocmd!
  autocmd BufRead *.cc setlocal foldmethod=syntax
  autocmd BufRead BUILD,*.log setlocal nospell
  autocmd BufRead *.vim
        \ setlocal filetype=vim sw=2 ts=2 sts=2 et
        \ tw=80 foldlevel=0 foldmethod=marker nospell
  autocmd BufRead *.json setlocal filetype=json
  autocmd FileType conf setlocal nospell
  autocmd FileType vtd if ! &diff | execute 'VtdView' | execute 'normal A' | endif
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
