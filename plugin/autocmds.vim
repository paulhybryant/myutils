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
  autocmd FileType vtd execute 'VtdView' | execute 'normal A'
augroup END

autocmd BufEnter * call myutils#SyncNTTree()
