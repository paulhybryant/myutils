let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Converts dos format files to unix format files
command! Dos2Unix keepjumps call myutils#Dos2unixFunction()

" Close the buffer window with confirmation
command! Bclose call myutils#bufclose#BufcloseCloseIt(1)

" Wrap the selected text in folds
command! -range -nargs=* WIF <line1>,<line2>call myutils#WrapInFold(<f-args>)

" Create mappings to toggle global boolean (0/1) vars
command! -nargs=+ MapToggleVar call myutils#MapToggleVar(<f-args>)

command! -nargs=* -complete=file -bang E
      \ call myutils#MultiEdit('<bang>', <f-args>)
command! -nargs=+ -complete=command DC call myutils#DechoCmd(<q-args>)
command! -nargs=+ InsertRepeated call myutils#InsertRepeated(<f-args>)

" Deprecated in favor of vim-onoff
" command! -nargs=+ MapToggle call myutils#MapToggle(<f-args>)
