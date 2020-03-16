" designed for vim 8+
let skip_defaults_vim=1

"

" common vim settings
set nocompatible
set ruler
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent
set smarttab
set autoindent
" FIXME turn wrapping off for everything but text files
set formatoptions=tcqrn12

" Avoid most of the 'Hit Enter ...' messages
set shortmess=aoOtI
"set cmdheight=2

" more reasonable characters to list with `:set list`
set listchars=tab:→\ ,eol:↲,nbsp:␣,space:·,trail:·,extends:⟩,precedes:⟨

" prevents truncated yanks, deletes, etc.
" 20 registers, 1000 lines max, up to 10kb in each
set viminfo='20,<1000,s1000

" 74 columns is still the safest width for most terminals especially
" considering Vim with line numbering chews up five of them
set textwidth=74
set nobackup
set noswapfile
set nowritebackup
set laststatus=0
set icon
set nohlsearch
set noincsearch
set linebreak

" manual folding by default (zf/zd)
set foldmethod=manual

" turn off bracket matching
let g:loaded_matchparen=1
set noshowmatch

if $PLATFORM == 'mac'
  " required for mac delete to work
  set backspace=indent,eol,start
endif

" source $PWD/.vimrc securely allowing per project vim config
set exrc
set secure

syntax enable
filetype plugin on

" memory management
set hidden
set history=100

" plugins
if ! filereadable(expand('~/.vim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.vim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.vim/autoload/plug.vim
endif

" Plugins installed
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'vim-pandoc/vim-pandoc'
Plug 'cespare/vim-toml'
Plug 'gabesoft/vim-ags'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

" enable omni-completion
set omnifunc=syntaxcomplete#Complete

set background=dark
colorscheme delek

" force vimscript to never fold
au Filetype vim setlocal nofoldenable

" backup if fatih fails (again)
autocmd vimleavepre *.go !gofmt -w %
autocmd Filetype go setlocal ts=6 sw=6 sts=0 expandtab

" let me out of editing a go file even if there are syntax errors
let g:go_fmt_fail_silently = 0

" syntax helpers

"au bufnewfile,bufRead *.bash* set ft=sh
au bufnewfile,bufRead *.profile set filetype=sh
au bufnewfile,bufRead *.crontab set filetype=crontab
au bufnewfile,bufRead *ssh/config set filetype=sshconfig
au bufnewfile,bufRead *gitconfig set filetype=gitconfig
au bufnewfile,bufread /tmp/psql.edit.* set syntax=sql

" let status and other commands see the type of the current file
au bufnewfile,bufread * call system("echo " . &filetype . " > $HOME/.vim/curfiletype")
au vimleavepre * call system("echo > $HOME/.vim/curfiletype" )

" displays all the syntax rules for current position, useful
" when writing vimscript syntax plugins

function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" start at the last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Update binds when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" Window switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" function keys
map <F1> :set number!<CR> :set relativenumber!<CR>
nmap <F2> :call <SID>SynStack()<CR>
set pastetoggle=<F3>
map <F4> :set list!<CR>
map <F5> :set cursorline!<CR>
map <F7> :set spell!<CR>

" no arrow keys
noremap <up> :echoerr "Use k instead"<CR>
noremap <down> :echoerr "Use j instead"<CR>
noremap <left> :echoerr "Use h instead"<CR>
noremap <right> :echoerr "Use l instead"<CR>
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

" Write a file with sudo (w!!)
cmap w!! W !sudo tee % >/dev/null

" ctrlp
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --path-to-ignore ~/.ignore -g ""'
endif
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" vim-ags
" Search for the word under cursor
nnoremap <Leader>s :Ags<Space><C-R>=expand('<cword>')<CR><CR>
" Search for the visually selected text
vnoremap <Leader>s y:Ags<Space><C-R>='"' . escape(@", '"*?()[]{}.') . '"'<CR><CR>
" Run Ags
nnoremap <Leader>ag :Ags<Space>
" Quit Ags
nnoremap <Leader><Leader>a :AgsQuit<CR>

" Nerdtree {{{
nmap <C-n> :NERDTreeToggle<CR>
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle
let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeIgnore = ['^node_modules$']

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
"}}}

" gitgutter
if exists('&signcolumn')
  set signcolumn="yes"
else
  let g:gitgutter_sign_column_always = 1
endif

let g:gitgutter_max_signs = 250

" read personal/private vim configuration (keep last to override)
set rtp^=~/.vimpersonal
set rtp^=~/.vimprivate
