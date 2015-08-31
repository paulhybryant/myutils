let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

" Converts dos format files to unix format files
command! Dos2Unix keepjumps call myutils#Dos2unixFunction()
