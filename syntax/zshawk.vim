source $VIMRUNTIME/syntax/zsh.vim
unlet b:current_syntax

syntax include @awk $VIMRUNTIME/syntax/awk.vim
syntax region awkinq start=/'/ end=/'/ contains=@awk

let b:current_syntax='zshawk'
