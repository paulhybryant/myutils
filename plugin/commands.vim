let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Converts dos format files to unix format files
command! Dos2Unix keepjumps call myutils#Dos2unixFunction()

" Close the buffer window with confirmation
command! Bclose call myutils#bufclose#BufcloseCloseIt(1)

" Open closed buffer in reverse close order
command! Bunclose call myutils#bufclose#BufcloseUncloseIt()

" Wrap the selected text in folds
command! -range -nargs=* WIF <line1>,<line2>call myutils#WrapInFold(<f-args>)

" Create mappings to toggle global boolean (0/1) vars
command! -nargs=+ MapToggleVar call myutils#MapToggleVar(<f-args>)

command! -nargs=* -complete=file -bang E
      \ call myutils#MultiEdit('<bang>', <f-args>)

command! -nargs=+ -complete=command DebugCmd call myutils#DechoCmd(<q-args>)

command! -nargs=+ InsertRepeated call myutils#InsertRepeated(<f-args>)

command! -range SortFolds <line1>,<line2>call myutils#SortFoldByFoldtext()

command! -range -nargs=+ SortWords <line1>,<line2>call myutils#SortWords(<f-args>)

command! -nargs=+ MapToggle call myutils#MapToggle(<f-args>)

command! -bar RangerChooser call myutils#RangerChooser()

command! -nargs=+ -complete=expression DebugEcho call myutils#Decho(<args>)
