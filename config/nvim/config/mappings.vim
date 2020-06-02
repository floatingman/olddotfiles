"###################################################################################
"       __  ___                      _
"      /  |/  /____ _ ____   ____   (_)____   ____ _ _____
"     / /|_/ // __ `// __ \ / __ \ / // __ \ / __ `// ___/
"    / /  / // /_/ // /_/ // /_/ // // / / // /_/ /(__  )
"   /_/  /_/ \__,_// .___// .___//_//_/ /_/ \__, //____/
"                 /_/    /_/               /____/
"
"###################################################################################

"***********************************************************************************

" Main Vim Keybinds

"***********************************************************************************

" Window Navigation
" Navigate to left window.
nnoremap <C-h> <C-w>h
" Navigate to down window.
nnoremap <C-j> <C-w>j
" Navigate to top window.
nnoremap <C-k> <C-w>k
" Navigate to right window.
nnoremap <C-l> <C-w>l
" Horizontal split then move to bottom window.
nnoremap <Leader>- <C-w>s
" Vertical split then move to right window.
nnoremap <Leader>\| <C-w>v<C-w>l
" Cycle tabs with Tab and Shift+Tab
nnoremap<silent> <Tab> :bnext<CR>
nnoremap<silent> <S-Tab> :bprevious<CR>
" Kill buffer with Space+bk
nnoremap<silent> <Space>bk :bdelete<CR>

nnoremap [q   :cprevious<CR>
nnoremap ]q   :cnext<CR>
nnoremap [Q   :cfirst<CR>
nnoremap ]Q   :clast<CR>

" Copying
nmap <leader><leader> V
nmap <leader>y "+y

" For simple sizing of splits.
map - <C-W>-
map + <C-W>+
nnoremap <silent> <Leader>vr :vertical resize 30<CR>
nnoremap <silent> <Leader>r+ :vertical resize +5<CR>
nnoremap <silent> <Leader>r- :vertical resize -5<CR>

" Faster ESC
inoremap jk <ESC>
inoremap kj <ESC>

" function keys
map <F1> :set number!<CR> :set relativenumber!<CR>
nmap <F2> :call <SID>SynStack()<CR>
set pastetoggle=<F3>
map <F5> :set cursorline!<CR>

" Indent controls
" Reselect text ater indent/unindent.
vnoremap < <gv
vnoremap > >gv
" Tab to indent in visual mode.
vnoremap <Tab> >gv
" Shift+Tab to unindent in visual mode.
vnoremap <S-Tab> <gv

" Lazydocker
nnoremap <silent> <Leader>ld :call ToggleLazyDocker()<CR>

" Write a file with sudo (w!!)
cmap w!! W !sudo tee % >/dev/null

" Redraw syntax highlighting from start of file.
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Check file in shellcheck:
map <leader>c :!clear && shellcheck %<CR>

" Insert timestamp
map <leader>n :r!date<cr>
