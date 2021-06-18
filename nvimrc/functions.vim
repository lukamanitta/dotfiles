" Functions
" Add argument (can be negative, default 1) to global variable i.
" Return value of i before the change.
" TODO: Add jumping to line (use scripts from file-line.vim ?)
function! OpenFileInPrevWindow()
    let cfile = expand("<cfile>")
    wincmd p
    execute "edit " . cfile
endfunction
nmap <leader>oF :call OpenFileInPrevWindow()<CR>
nmap <leader>of gF

" Terminal shortcuts (run in background)
function! GotoBuffer(ctrlId)
    if (a:ctrlId > 9) || (a:ctrlId < 0)
        echo "CtrlID must be between 0 - 9"
        return
    end

    let contents = g:win_ctrl_buf_list[a:ctrlId]
    if type(l:contents) != v:t_list
        echo "Nothing There"
        return
    end

    let bufh = l:contents[1]
    call nvim_win_set_buf(0, l:bufh)
endfunction

let g:win_ctrl_buf_list = [0, 0, 0, 0]
function! SetBuffer(ctrlId)
    if has_key(b:, "terminal_job_id") == 0
        echo "You must be in a terminal to execute this command"
        return
    end
    if (a:ctrlId > 9) || (a:ctrlId < 0)
        echo "CtrlID must be between 0 - 9"
        return
    end

    let g:win_ctrl_buf_list[a:ctrlId] = [b:terminal_job_id, nvim_win_get_buf(0)]
endfunction

" Go to background terminals
nmap <leader>t1 :call GotoBuffer(0)<CR>
nmap <leader>t2 :call GotoBuffer(1)<CR>
nmap <leader>t3 :call GotoBuffer(2)<CR>
nmap <leader>t4 :call GotoBuffer(3)<CR>

" Set background terminals
nmap <leader>ts1 :call SetBuffer(0)<CR>
nmap <leader>ts2 :call SetBuffer(1)<CR>
nmap <leader>ts3 :call SetBuffer(2)<CR>
nmap <leader>ts4 :call SetBuffer(3)<CR>

function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

function! Inc(...)
  let result = g:i
  let g:i += a:0 > 0 ? a:1 : 1
  return result
endfunction
