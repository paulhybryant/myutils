" Get the number of normal buffers, by normal it means it is not special
" buffers that are for exampe hidden {{
function! myutils#GetNumBuffers()
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction
" }}

" Get the next number of normal buffers after 'cur_bufnr'. The next number is
" the smallest buffer number that is larger than 'cur_bufnr'. If 'cur_bufnr'
" is the largest buffer number, return the largest buffer number that is
" smaller than 'cur_bufnr'. Returns 'cur_bufnr' if there is only one normal
" buffer. {{
function! myutils#NextBufNr(cur_bufnr)
    let l:buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    if len(l:buffers) == 1
        return a:cur_bufnr
    endif

    for i in range(0, len(l:buffers))
        if l:buffers[i] == a:cur_bufnr
            if i == len(l:buffers) - 1
                return l:buffers[i - 1]
            else
                return l:buffers[i + 1]
            endif
        endif
    endfor
endfunction
" }}

" Whether the current window is the NERDTree window {{
function! myutils#IsInNERDTreeWindow()
  return exists("b:NERDTreeType")
endfunction
" }}
