" displays all the syntax rules for current position, useful
" when writing vimscript syntax plugins
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" REQUIRED FOR LAZYGIT
" Creates a floating window with a most recent buffer to be used
function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.6)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    autocmd BufWipeout <buffer> exe 'bwipeout '.s:buf
endfunction

" When term starts, auto go into insert mode
autocmd TermOpen * startinsert

" Turn off line numbers etc
autocmd TermOpen * setlocal listchars= nonumber norelativenumber

function! ToggleTerm(cmd)
    if empty(bufname(a:cmd))
        call CreateCenteredFloatingWindow()
        call termopen(a:cmd, { 'on_exit': function('OnTermExit') })
    else
        bwipeout!
    endif
endfunction

" Open Project
function! ToggleProject()
    call ToggleTerm('tmuxinator-fzf-start.sh')
endfunction

function! ToggleScratchTerm()
    call ToggleTerm('bash')
endfunction

function! ToggleLazyGit()
    call ToggleTerm('lazygit')
endfunction

function! ToggleLazyDocker()
    call ToggleTerm('lazydocker')
endfunction


function! OnTermExit(job_id, code, event) dict
    if a:code == 0
        bwipeout!
    endif
endfunction

" zoom function that opens the current buffer in a new tab
" found at: github.com/junegunn/dotfiles/blob/master/vimrc
"
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>
