""
" @private
" Formatter: xmllint
function! vimutils#xmlformatter#GetXMLFormatter() abort
  let l:formatter = {
      \ 'name': 'xml-format',
      \ 'setup_instructions': 'Install xmllint'}

  function l:formatter.IsAvailable() abort
    return executable('xmllint')
  endfunction

  function l:formatter.AppliesToBuffer() abort
    if &filetype is# 'xml'
      return 1
    endif
  endfunction

  ""
  " Reformat buffer with xmllint
  function l:formatter.FormatRanges(ranges) abort
    if empty(a:ranges)
      return
    endif

    let l:cmd = [
        \ 'xmllint',
        \ '--format', '-']
    let l:input = join(getline(1, line('$')), "\n")
    let l:result = maktaba#syscall#Create(l:cmd).WithStdin(l:input).Call()
    let l:formatted = split(l:result.stdout, "\n")
    call maktaba#buffer#Overwrite(1, line('$'), l:formatted[0:])
  endfunction

  return l:formatter
endfunction
