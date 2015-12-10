let [s:plugin, s:enter] = maktaba#plugin#Enter(expand('<sfile>:p'))
if !s:enter
  finish
endif

""
" Exit vim if all existing buffers is one of these types
call s:plugin.Flag('bufclose_skip_types', [])

""
" Use cmdline-window to replace command mode
call s:plugin.Flag('use_cmdwin', 0)
