let s:plugin = maktaba#plugin#Get('myutils')

" Confirm saving buffers before it is closed and quit vim if the closed buffer
" is the last buffer.
function! myutils#bufclose#BufcloseCloseIt(confirm) " {{{
  " Whether the current window is the NERDTree window
  if exists('b:NERDTreeType')
    NERDTreeToggle
    return
  endif

  if &mod && a:confirm
    if input('Save changes?(y/n) ') == 'y'
      execute('w!')
    endif
  endif

  let l:currentBufNum = bufnr('%')
  let l:next_bufnr = s:NextBufNr(l:currentBufNum)
  if l:next_bufnr == -1
    " Current buffer is a special buffer (help, NERDTree, etc)
    execute('bdelete! '.l:currentBufNum)
  elseif l:next_bufnr == l:currentBufNum
    " Current buffer is the only listed buffer
    execute('qa!')
  else
    if s:GetNumberOfNormalWindows() == 1
      execute('b! ' . l:next_bufnr)
      execute('bdelete! '.l:currentBufNum)
    else
      execute 'wincmd q'
    endif
    " execute('bwipeout! '.l:currentBufNum)
  endif
endfunction
" }}}


" Get the next number of normal buffers after 'cur_bufnr'. The next number is
" the smallest buffer number that is larger than 'cur_bufnr'. If 'cur_bufnr'
" is the largest buffer number, return the largest buffer number that is
" smaller than 'cur_bufnr'. Returns 'cur_bufnr' if there is only one normal
" buffer.
function! s:NextBufNr(cur_bufnr) " {{{
    let l:buffers = s:GetListedBuffers()

    if &buftype == 'quickfix'
        return -1
    endif

    for var in s:plugin.Flag('bufclose_skip_types')
        if exists('b:' . var)
            return -1
        endif
    endfor

    if len(l:buffers) == 1
        if l:buffers[0] == a:cur_bufnr
            return l:buffers[0]
        else
            return -1
        endif
    endif

    for i in range(0, len(l:buffers) - 1)
        if l:buffers[i] == a:cur_bufnr
            if i == len(l:buffers) - 1
                return l:buffers[i - 1]
            else
                return l:buffers[i + 1]
            endif
        endif
    endfor
    return -1
endfunction
" }}}


" Get the array of normal buffers, by normal it means it is not special buffer
" that is for exampe hidden
function! s:GetListedBuffers()  " {{{
    return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction
" }}}


" Get the number of normal listed buffers, by normal it means it is not
" special buffers that are for exampe hidden
function! s:GetNumListedBuffers() " {{{
    return len(s:GetListedBuffers())
endfunction
" }}}


" Get the total number of normal windows
function! s:GetNumberOfNormalWindows() " {{{
    return len(filter(range(1, winnr('$')), 'buflisted(winbufnr(v:val))'))
endfunction
" }}}
