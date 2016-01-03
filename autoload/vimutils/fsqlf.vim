""
" @private
" Formatter: fsqlf
function! vimutils#fsqlf#GetSQLFormatter() abort
  let l:formatter = {
      \ 'name': 'fsqlf',
      \ 'setup_instructions': 'Install fsqlf (https://github.com/dnsmkl/fsqlf)'}

  function l:formatter.IsAvailable() abort
    return executable('fsqlf')
  endfunction

  function l:formatter.AppliesToBuffer() abort
    if &filetype is# 'sql'
      return 1
    endif
  endfunction

  ""
  " Reformat buffer with fsqlf, only targeting [ranges] if given.
  " The range must contain a complete sql query, otherwise fsalf would fail.
  function l:formatter.FormatRanges(ranges) abort
    if empty(a:ranges)
      return
    endif

    let l:cmd = 'fsqlf'
    let l:lines = getline(1, line('$'))
    for [l:startline, l:endline] in a:ranges
      call maktaba#ensure#IsNumber(l:startline)
      call maktaba#ensure#IsNumber(l:endline)

      " Hack range formatting by formatting range individually, ignoring context.
      let l:input = join(l:lines[l:startline - 1 : l:endline - 1], "\n")

      let l:result = maktaba#syscall#Create(l:cmd).WithStdin(l:input).Call()
      let l:formatted = split(l:result.stdout, "\n")

      " Special case empty slice: neither l:lines[:0] nor l:lines[:-1] is right.
      let l:before = l:startline > 1 ? l:lines[ : l:startline - 2] : []
      let l:full_formatted = l:before + l:formatted + l:lines[l:endline :]

      call maktaba#buffer#Overwrite(1, line('$'), l:full_formatted)
    endfor
  endfunction

  return l:formatter
endfunction
