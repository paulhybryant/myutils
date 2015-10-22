"============================================================================
"File:        shellcheck.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  LCD 47 <lcd047 at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if exists('g:loaded_syntastic_zsh_shellcheck_checker')
    finish
endif
let g:loaded_syntastic_zsh_shellcheck_checker = 1
if exists('g:syntastic_zsh_checkers')
  call add(g:syntastic_zsh_checkers, 'shellcheck')
else
  let g:syntastic_zsh_checkers = ['shellcheck']
endif

runtime! syntax_checkers/sh/*.vim

let g:syntastic_zsh_shellcheck_args = '-s bash -x'

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'zsh',
    \ 'name': 'shellcheck',
    \ 'redirect': 'sh/shellcheck'})

" vim: set sw=4 sts=4 et fdm=marker:
