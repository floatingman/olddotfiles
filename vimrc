" designed for vim 8+
let skip_defaults_vim=1

let mapleader =","

if ! filereadable(expand('~/.vim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.vim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.vim/autoload/plug.vim
endif

" Plugins installed
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'gabesoft/vim-ags'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()
"

" common vim settings
set nocompatible
set encoding=utf-8
set undofile
set visualbell
set splitbelow
set splitright
set autoread
" Automatically save before commands like :next and :make
set autowrite
" Show the editor mode
set showmode
" Show state of keyboard input
set showcmd
set exrc
set secure
set nojoinspaces
set clipboard+=unnamed
set completeopt=preview
set nu
set ruler
" Show the status line
set laststatus=0
set icon
set infercase
set diffopt+=filler,vertical
set breakindent
set t_Co=256
set expandtab
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nowrap
set linebreak
set number
"set relativenumber

" FIXME turn wrapping off for everything but text files
set formatoptions=tcqrn12

" Avoid most of the 'Hit Enter ...' messages
set shortmess=aoOtI

" more reasonable characters to list with `:set list`
set listchars=tab:→\ ,eol:↲,nbsp:␣,space:·,trail:·,extends:⟩,precedes:⟨

" prevents truncated yanks, deletes, etc.
" 20 registers, 1000 lines max, up to 10kb in each
set viminfo='20,<1000,s1000
set textwidth=74
" Some basics:
filetype plugin indent on
syntax on
set ttyfast

"Show whitespace characters
set list

" Follow line indentation
set autoindent

" Set the minimum number of lines to keep above and below cursor
set scrolloff=5

" buffers & tabs
set hidden
map [b :bprevious<cr>
map ]b :bnext<cr>
map <leader>b :buffers<cr>

" Don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
  augroup undoskip
    autocmd!
    silent! autocmd BufWritePre
          \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
          \ setlocal noundofile
  augroup END
endif

" Don't keep viminfo for files in temp directories or shm
if has('viminfo')
  if has('autocmd')
    augroup viminfoskip
      autocmd!
      silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal viminfo=
    augroup END
  endif
endif


" displays all the syntax rules for current position, useful
" when writing vimscript syntax plugins

function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" start at last place you were editing

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Insert timestamp
map <leader>n :r!date<cr>

set background=dark
colorscheme delek

" gutentags
let g:gutentags_cache_dir = $HOME . '/.cache/ctags'


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

" better-whitespace
map <leader>W :ToggleWhitespace<CR>
let g:better_whitespace_enabled = 0

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

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Splits open at the bottom and right
set splitbelow splitright

" Check file in shellcheck:
map <leader>c :!clear && shellcheck %<CR>

" Automatically deletes all trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
autocmd BufWritePost ~/.bmdirs,~/.bmfiles !shortcuts

" Update binds when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" syntax helpers

au bufnewfile,bufRead *.bash* set ft=sh
au bufnewfile,bufRead *.profile set filetype=sh
au bufnewfile,bufRead *.crontab set filetype=crontab
au bufnewfile,bufRead *ssh/config set filetype=sshconfig
au bufnewfile,bufRead *gitconfig set filetype=gitconfig
au bufnewfile,bufread /tmp/psql.edit.* set syntax=sql

" let status and other commands see the type of the current file
au bufnewfile,bufread * call system("echo " . &filetype . " > $HOME/.vim/curfiletype")
au vimleavepre * call system("echo > $HOME/.vim/curfiletype" )

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" Restart yabai everytime config is updated
autocmd BufWritePost ~/.confg/yabai/yabairc !brew services restart yabai

" Restart skhd everytime config is updated
autocmd BufWritePost ~/.skhdrc !brew services restart skhd

" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red

" Flag tabs instead of spaces
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/

" Flag Unnecessary Whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Make backspaces more powerfull
set backspace=indent,eol,start

" enable omni-completion
set omnifunc=syntaxcomplete#Complete

" gitgutter
if exists('&signcolumn')
  set signcolumn="yes"
else
  let g:gitgutter_sign_column_always = 1
endif

let g:gitgutter_max_signs = 250

" Rainbows!
let g:rainbow_active = 1

" Auto indent pasted text
"nnoremap p p=`]<C-o>
"nnoremap P P=`]<C-o>

" function keys
map <F1> :set number!<CR> :set relativenumber!<CR>
nmap <F2> :call <SID>SynStack()<CR>
set pastetoggle=<F3>
map <F4> :set list!<CR>
map <F5> :set cursorline!<CR>
map <F7> :set spell!<CR>


" Write a file with sudo (w!!)
cmap w!! W !sudo tee % >/dev/null

" Use kj for escape
inoremap kj <Esc>

" Folds
" manual folding by default (zf/zd)
set foldmethod=manual   "fold based on indent

"" Toggle folds with space.
nnoremap <Space> za
vnoremap <Space> za

" Redraw syntax highlighting from start of file.
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Search
"" Start searching as characters are typed
set incsearch

"" Highlight search results
set hlsearch
set showmatch

"" Ignore case in searches, but smartly
set ignorecase
set smartcase

"" Disable search highlighting (<leader><space>)
nnoremap <leader><space> :noh<cr>

" Window switching
"" Switch between windows with <Leader><number>
let i = 1
while i <= 9
  execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd W<CR>'
  let i = i + 1
endwhile

" Window switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Paste from system clipboard in insert mode (Ctrl+v)
imap <C-v> <ESC>"+gpa

" GnuPG Extensions
" Tell the GnuPG plugin to armor new files
let g:GPGPreferArmor=1

" Tell the GnuPG plugin to sign new files
let g:GPGPreferSign=1

augroup GnuPGExtra
  " Set extra file options.
  autocmd BufReadCmd,FileReadCmd *.\(gpg\|asc\|pgp\) call SetGPGOptions()
  " Automatically close unmodified files after inactivity.
  autocmd CursorHold *.\(gpg\|asc\|pgp\) quit
augroup END

function SetGPGOptions()
  " set updatetime to 1 minute.
  set updatetime=60000
  " Fold at markers.
  set foldmethod=marker
  " Automatically close all folds.
  set foldclose=all
  " Only open folds with insert commands.
  set foldopen=insert
endfunction

" Some servers have issues with backup files, see #649
set nobackup
set noswapfile
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes
