let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Converts dos format files to unix format files
command! Dos2Unix keepjumps call vimutils#Dos2unixFunction()

" Close the buffer window with confirmation
command! Bclose call vimutils#bufclose#BufcloseCloseIt(1)

" Open closed buffer in reverse close order
command! Bunclose call vimutils#bufclose#BufcloseUncloseIt()

" Wrap the selected text in folds
command! -range -nargs=* WIF <line1>,<line2>call vimutils#WrapInFold(<f-args>)

" Create mappings to toggle global boolean (0/1) vars
command! -nargs=+ MapToggleVar call vimutils#MapToggleVar(<f-args>)

command! -nargs=* -complete=file -bang E
      \ call vimutils#MultiEdit('<bang>', <f-args>)

command! -nargs=+ -complete=command DebugCmd call vimutils#DechoCmd(<q-args>)

command! -nargs=+ InsertRepeated call vimutils#InsertRepeated(<f-args>)

command! -range SortFolds <line1>,<line2>call vimutils#SortFoldByFoldtext()

command! -range -nargs=+ SortWords <line1>,<line2>call vimutils#SortWords(<f-args>)

command! -nargs=+ MapToggle call vimutils#MapToggle(<f-args>)

command! -bar RangerChooser call vimutils#RangerChooser()

command! -nargs=+ -complete=expression DebugEcho call vimutils#Decho(<args>)
