" Install vim-plugged if not already installed
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.config/nvim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
endif
call plug#begin('~/.config/nvim/plugged')

" lets be sensible
Plug 'tpope/vim-sensible'

" Syntax
Plug 'w0rp/ale'
Plug 'pangloss/vim-javascript'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" Comments
Plug 'scrooloose/nerdcommenter'

" Auto Save
Plug '907th/vim-auto-save'

" NerdTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Tagbar
Plug 'liuchengxu/vista.vim'

"" Plugins used by pigmonkey (https://github.com/pigmonkey)
Plug 'jamessan/vim-gnupg'
" Plug 'roman/golden-ratio'
" Plug 'hynek/vim-python-pep8-indent'
" Plug 'dhruvasagar/vim-table-mode'
" Plug 'ledger/vim-ledger'
" Plug 'othree/html5.vim'
" Plug 'hail2u/vim-css3-syntax'

Plug 'rbgrouleff/bclose.vim'
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
" Plug 'ryanoasis/vim-devicons'
Plug 'editorconfig/editorconfig-vim'
" Plug 'easymotion/vim-easymotion'
" Plug 'haya14busa/incsearch-easymotion.vim'
" Plug 'haya14busa/incsearch.vim'
" Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
" Plug 'sodapopcan/vim-twiggy'
" Plug 'tpope/vim-repeat'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rhysd/conflict-marker.vim'
" Plug 'sbdchd/neoformat'
" Plug 'sheerun/vim-polyglot'
" Plug 'trevordmiller/nova-vim'
Plug 'whatyouhide/vim-lengthmatters'
" Plug 'edkolev/promptline.vim'
" Plug 'xolox/vim-misc'
" Plug 'skywind3000/asyncrun.vim'
Plug 'ludovicchabant/vim-gutentags'
" Plug 'will133/vim-dirdiff'
"" Markdown editing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'vimwiki/vimwiki'
" Plug 'plasticboy/vim-markdown'
" Plug 'honza/vim-snippets'
Plug 'elzr/vim-json'
" Plug 'godlygeek/tabular'
Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}

" Statusbar
Plug 'itchyny/lightline.vim'

"" Python coding
" Plug 'vim-scripts/indentpython.vim'
" Plug 'nvie/vim-flake8'
" Plug 'vim-scripts/Pydiction'
" Plug 'klen/rope-vim'
" Plug 'vifm/vifm.vim'
" Plug 'kovetskiy/sxhkd-vim'
Plug 'pearofducks/ansible-vim'

"" Jenkins
Plug 'martinda/Jenkinsfile-vim-syntax'

"" Searching
Plug 'rking/ag.vim'
Plug 'gabesoft/vim-ags'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf'

"" Code Formating
Plug 'vim-scripts/Align'
Plug 'Raimondi/delimitMate'

"" Color Schemes
Plug 'flazz/vim-colorschemes'
"" Buffer Navigation
Plug 'sjbach/lusty'
call plug#end()
