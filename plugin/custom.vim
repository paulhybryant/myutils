" hi Search term=reverse ctermfg=0 ctermbg=13 guibg=#BBBB00
" hi IncSearch term=reverse ctermbg=11 gui=reverse
hi Todo term=standout ctermbg=None ctermfg=14 guifg=Yellow guibg=Black

cnoreabbrev q qa

augroup FiletypeFormat
  autocmd!
  autocmd BufRead *.cc setlocal foldmethod=syntax
  " Disable spell check for log file and BUILD
  autocmd BufRead BUILD setlocal nospell
  autocmd BufRead *.log setlocal nospell
  autocmd FileType conf setlocal nospell
  " Use numbers.vim for more intelligent number toggle
  " autocmd FileType vimshell setlocal nospell | set nonumber
  autocmd BufRead *.vim
      \ setlocal sw=2 | setlocal ts=2 | setlocal softtabstop=2
  " autocmd BufEnter * hi Todo term=standout ctermfg=11 ctermbg=none guifg=Blue guibg=Black

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml,xhtml so ~/.vim/bundle/HTML-AutoCloseTag/ftplugin/html_autoclosetag.vim
  " autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  " autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
  autocmd FileType autohotkey setlocal omnifunc=syntaxcomplete#Complete
augroup END
