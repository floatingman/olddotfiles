let mapleader =","

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.config/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
endif

" Plugins installed
	call plug#begin('~/.config/nvim/plugged')
	Plug 'tpope/vim-surround'
	Plug 'scrooloose/nerdtree'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'
	Plug 'PotatoesMaster/i3-vim-syntax'
	Plug 'vimwiki/vimwiki'
	Plug 'bling/vim-airline'
	Plug 'tpope/vim-commentary'
	Plug 'scrooloose/nerdcommenter'
	Plug 'tmhedberg/SimpylFold'
	Plug 'vim-scripts/indentpython.vim'
	Plug 'Valloric/YouCompleteMe'
	Plug 'vim-syntastic/syntastic'
	Plug 'nvie/vim-flake8'
	Plug 'kien/ctrlp.vim'
	Plug 'vim-scripts/Pydiction'
	Plug 'klen/rope-vim'
	Plug 'vifm/vifm.vim'
	Plug 'kovetskiy/sxhkd-vim'
	Plug 'plasticboy/vim-markdown'
	Plug 'honza/vim-snippets'
	Plug 'ervandew/supertab'
	Plug 'elzr/vim-json'
	Plug 'godlygeek/tabular'
	Plug 'vim-pandoc/vim-pandoc-syntax'
	Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
	Plug 'godlygeek/tabular'
	Plug 'pearofducks/ansible-vim'
	call plug#end()
	"

set bg=light
set go=a
set mouse=a
set nohlsearch
set ignorecase
set smartcase
set incsearch
set clipboard+=unnamedplus

" Some basics:
	set nocompatible
	filetype plugin indent on
	syntax on
	set encoding=utf-8
	set number relativenumber
	set tabstop=2
	set softtabstop=2
	set shiftwidth=2
" Folding
	set foldmethod=indent
	set foldlevel=99
	" Enable folding with spacebar
	nnoremap <space> za
	" See docstrings for folded code
	let g:SimpylFold_docstring_preview=1

" Enable autocompletion:
	set wildmode=longest,list,full

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set linebreak<CR>

"" Limelight helps with editing
	let g:limelight_conceal_ctermfg = 'gray'
	let g:limelight_conceal_ctermfg = 240
	let g:limelight_conceal_guifg = 'DarkGray'
	let g:limelight_conceal_guifg = '#777777'
	let g:limelight_deafault_coeffiecient = 0.7
	let g:limelight_paragraph_span = 1
	let g:limelight_bob = '^\s'
	let g:limelight_eop = '\ze\n^\s'
	let g:limelight_priority = -1
	autocmd! User GoyoEnter Limelight
	autocmd! User GoyoLeave Limelight!

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTREE

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck %<CR>

" Copy selected text to system clipboard (requires gvim/nvim/vim-xll installed):
	vnoremap <C-c> "+y
	map <C-p> "+P

" Enable Goyo by default for mutt writing
" Goyo's width will be the line limit in mutt.
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo

" Automatically deletes all trailing whitespace on save
	autocmd BufWritePre * %s/\s\+$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost ~/.bmdirs,~/.bmfiles !shortcuts

" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" Set web programming defaults
	au BufNewFile,BufRead *.js, *.html, *.css
				\ set tabstop=2
				\ set softtabstop=2
				\ set shiftwidth=2

" Use the below highlight group when displaying bad whitespace is desired
	highlight BadWhitespace ctermbg=red guibg=red

" Flag tabs instead of spaces
	au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/

" Flag Unnecessary Whitespace
	au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" YouCompleteMe config
	let g:ycm_autoclose_preview_window_after_completion=1
	map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Make backspaces more powerfull
	set backspace=indent,eol,start

" Make vim aware of virtualenv
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
	project_base_dir = os.environ['VIRTUAL_ENV']
	sys.path.insert(0, project_base_dir)
	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
	execfile(activate_this, dict(__file__=activate_this))
EOF

autocmd FileType python set omnifunc=pythoncomplete#Complete

" Set syntax highlighting
	let python_highlight_all=1

" Pydiction setup
	let g:pydiction_location = '/home/dnewman/.config/nvim/plugged/Pydiction/complete-dict'

" Markdown
	au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
	au FileType markdown set autoindent
	au FileType markdown set smartindent
	au FileType markdown set list
	au FileType markdown set textwidth=115
"" Markdown.vim
	let g:vim_markdown_folding_disabled = 1
	let g:vim_markdown_conceal = 0
	let g:tex_concearl = ""
	let g:vim_markdown_math = 1

	let g:vim_markdown_frontmatter = 1 " for YAML format
	let g:vim_markdown_toml_frontmatter = 1 " for TOML format
	let g:vim_markdown_json_frontmatter = 1 " for JSON format

"" Markdown Preview
let g:mkdp_auto_close = 0
nnoremap <M-m> :MarkdownPreview<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"
