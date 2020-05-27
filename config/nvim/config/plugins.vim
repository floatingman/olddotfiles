"#####################################################################################################
"                           ____     __                     _
"                          / __ \   / /  __  __   ____ _   (_)   ____    _____
"                         / /_/ /  / /  / / / /  / __ `/  / /   / __ \  / ___/
"                        / ____/  / /  / /_/ /  / /_/ /  / /   / / / / (__  )
"                       /_/      /_/   \__,_/   \__, /  /_/   /_/ /_/ /____/
"                                              /____/
"######################################################################################################

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
Plug 'ap/vim-css-color'

" Vim Javascript and node
Plug 'pangloss/vim-javascript'
Plug 'moll/vim-node'
" Improved Javacript goto file
Plug 'hotoo/jsgf.vim'
" Typescript
Plug 'leafgarland/typescript-vim'

" Language Packs
Plug 'sheerun/vim-polyglot'

" Comfy scroll
Plug 'yuttie/comfortable-motion.vim'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" Comments
Plug 'preservim/nerdcommenter'

" Auto Save
"Plug '907th/vim-auto-save'

" NERDTree
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" VIFM
Plug 'vifm/vifm.vim'

" Tagbar
Plug 'liuchengxu/vista.vim'

"" Plugins used by pigmonkey (https://github.com/pigmonkey)
Plug 'jamessan/vim-gnupg'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rhysd/conflict-marker.vim'
Plug 'whatyouhide/vim-lengthmatters'
"Plug 'ludovicchabant/vim-gutentags'
Plug 'vim-utils/vim-man'

"" Markdown editing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'honza/vim-snippets'
Plug 'elzr/vim-json'
Plug 'godlygeek/tabular'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" vim-hexcolor
Plug 'etdev/vim-hexcolor'

" Statusbar
Plug 'itchyny/lightline.vim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

" Custom start page
Plug 'mhinz/vim-startify'

"" ansible
Plug 'pearofducks/ansible-vim'

"" Jenkins
Plug 'martinda/Jenkinsfile-vim-syntax'

"" Searching
Plug 'rking/ag.vim'
Plug 'gabesoft/vim-ags'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf'
Plug 'jremmen/vim-ripgrep'

"" Color Schemes
Plug 'dylanaraps/wal.vim'
Plug 'deviantfero/wpgtk.vim'
Plug 'jacoborus/tender.vim'
Plug 'morhetz/gruvbox'
Plug 'tomasr/molokai'
Plug 'itchyny/landscape.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'nice/sweater'
Plug 'NLKNguyen/papercolor-theme'
Plug 'jonathanfilip/vim-lucius'

" Add DevIcons
Plug 'ryanoasis/vim-devicons'

" Emoji support
Plug 'junegunn/vim-emoji'

"" Indent guides
Plug 'Yggdroot/indentLine'

" Auto pairs
Plug 'jiangmiao/auto-pairs'

" Undo
Plug 'mbbill/undotree'

" vimwiki
Plug 'vimwiki/vimwiki'
call plug#end()
