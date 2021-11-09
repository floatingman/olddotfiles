"" Plugins
" Install vim-plugged if not already installed
if ! filereadable(expand('~/.vim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.vim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.vim/autoload/plug.vim
endif
call plug#begin('~/.vim/plugged')

" Install plugins
Plug 'junegunn/fzf.vim', {'do': { -> fzf#install() }}
Plug 'mustache/vim-mustache-handlebars'
Plug 'vim-syntastic/syntastic'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-abolish'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-bundler'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-markdown'
Plug 'preservim/vim-pencil'
Plug 'tpope/vim-projectionist'
Plug 'digitaltoad/vim-pug'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'joker1007/vim-ruby-heredoc-syntax'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-unimpaired'
Plug 'posva/vim-vue'

call plug#end()