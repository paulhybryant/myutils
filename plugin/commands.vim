let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Converts dos format files to unix format files
command! Dos2Unix keepjumps call myutils#Dos2unixFunction()

" Close the buffer window with confirmation
command! Bclose call myutils#bufclose#BufcloseCloseIt(1)

" Wrap the selected text in folds
command! -range -nargs=1 WIF <line1>,<line2>call myutils#WrapInFold(<f-args>)
