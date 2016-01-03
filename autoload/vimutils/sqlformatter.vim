""
" @private
" Formatter: SQLUtilities
function! vimutils#sqlformatter#GetSQLFormatter() abort
  let l:formatter = {
      \ 'name': 'sql-format',
      \ 'setup_instructions': 'Install SQLUtilities (https://github.com/vim-scripts/SQLUtilities)'}

  function l:formatter.IsAvailable() abort
    return exists(':NeoBundle') && neobundle#is_sourced('SQLUtilities')
  endfunction

  function l:formatter.AppliesToBuffer() abort
    if &filetype is# 'sql'
      return 1
    endif
  endfunction

  ""
  " Reformat buffer with SQLUtilities, only targeting [ranges] if given.
  function l:formatter.FormatRanges(ranges) abort
    if empty(a:ranges)
      return
    endif

    for [l:startline, l:endline] in a:ranges
      call maktaba#ensure#IsNumber(l:startline)
      call maktaba#ensure#IsNumber(l:endline)
      execute l:startline . ',' . l:endline . 'SQLUFormatter'
    endfor
  endfunction

  return l:formatter
endfunction
