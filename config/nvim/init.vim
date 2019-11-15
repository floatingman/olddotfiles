let mapleader =","

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.config/nvim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
endif

" Plugins installed
  call plug#begin('~/.config/nvim/plugged')
  Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \}

  "" Completion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  "" Plugins used by pigmonkey (https://github.com/pigmonkey)
  Plug 'jamessan/vim-gnupg'
  Plug 'roman/golden-ratio'
  Plug 'jnurmine/Zenburn'
  Plug 'hynek/vim-python-pep8-indent'
  Plug 'chriskempson/base16-vim'
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'ledger/vim-ledger'
  Plug 'othree/html5.vim'
  Plug 'hail2u/vim-css3-syntax'


  Plug 'scrooloose/nerdtree'
  Plug 'airblade/vim-gitgutter'
  Plug 'benizi/vim-automkdir'
  Plug 'easymotion/vim-easymotion'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'haya14busa/incsearch-easymotion.vim'
  Plug 'haya14busa/incsearch.vim'
  Plug 'justinmk/vim-dirvish'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'sodapopcan/vim-twiggy'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'rhysd/conflict-marker.vim'
  Plug 'sbdchd/neoformat'
  Plug 'sheerun/vim-polyglot'
  Plug 'trevordmiller/nova-vim'
  Plug 'whatyouhide/vim-lengthmatters'
  Plug 'edkolev/promptline.vim'
  Plug 'xolox/vim-misc'
  Plug 'skywind3000/asyncrun.vim'
  Plug 'majutsushi/tagbar'
  Plug 'ludovicchabant/vim-gutentags'

  "" Markdown editing
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'PotatoesMaster/i3-vim-syntax'
  Plug 'vimwiki/vimwiki'
  Plug 'plasticboy/vim-markdown'
  Plug 'honza/vim-snippets'
  Plug 'elzr/vim-json'
  Plug 'godlygeek/tabular'
  Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}

  "" Mode Line config
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  "" Python coding
  Plug 'vim-scripts/indentpython.vim'
  Plug 'nvie/vim-flake8'
  Plug 'vim-scripts/Pydiction'
  Plug 'klen/rope-vim'

  Plug 'kien/ctrlp.vim'
  Plug 'vifm/vifm.vim'
  Plug 'kovetskiy/sxhkd-vim'
  Plug 'pearofducks/ansible-vim'

  "" Theme related
  Plug 'luochen1990/rainbow'

  "" Coffeescript
  Plug 'kchmck/vim-coffee-script'

  "" Colorscheme
  Plug 'morhetz/gruvbox'

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
  set laststatus=2
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
  " Allow mouse (is this sacrilege?)
  set mouse=a
  " Some basics:
  filetype plugin indent on
  syntax on
  set ttyfast

  "Show whitespace characters
  set list

  " Follow line indentation
  set autoindent

  " Use wildmenu for command line tab completion
  set wildmenu
  set wildmode=list:longest,full

  " Underline the current line
  set cursorline

  " Set the minimum number of lines to keep above and below cursor
  set scrolloff=5

  " buffers & tabs
  set hidden
  map [b :bprevious<cr>
  map ]b :bnext<cr>
  map <leader>b :buffers<cr>


  """""""""""""""""""
  " Temporary Files "
  """""""""""""""""""
  " https://gist.github.com/tejr/5890634

  " Don't backup files in temp directories or shm
  if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
  endif

  " Don't keep swap files in temp directories or shm
  if has('autocmd')
    augroup swapskip
      autocmd!
      silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noswapfile
    augroup END
  endif

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


  """"""""
  " Pass "
  """"""""

  augroup passconceal
    autocmd!

    " Create the second line if it does not already exist
    autocmd BufNewFile,BufRead */pass.*/* if line('$') == 1 | $put _ | endif

    " Jump to the second line
    autocmd BufNewFile,BufRead */pass.*/* 2

    " Conceal the first line with an asterisk
    autocmd BufNewFile,BufRead */pass.*/* syntax match Concealed '\%1l.*' conceal cchar=*
    autocmd BufNewFile,BufRead */pass.*/* set conceallevel=1

  augroup END


  " Insert timestamp
  map <leader>n :r!date<cr>

  set background=dark
  colorscheme gruvbox

" gutentags
  let g:gutentags_cache_dir = $HOME . '/.cache/ctags'

" ctrlp
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor --path-to-ignore ~/.ignore -g ""'
  endif
  nmap <C-N> :CtrlPTag<cr>
  nmap <C-K> :CtrlPBuffer<cr>

" better-whitespace
  map <leader>W :ToggleWhitespace<CR>
  let g:better_whitespace_enabled = 0

" lengthmatters
  map <leader>L :LengthmattersToggle<CR>
  let g:lengthmatters_on_by_default = 0
  let g:lengthmatters_start_at_column = 130

" Nerdtree
  nnoremap <F11> :NERDTreeToggle<cr>

" tagbar
  let g:tagbar_autoclose = 1
  nnoremap <F12> :TagbarToggle<cr>

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
  nnoremap <C-[> :NERDTreeToggle<cr>
  nnoremap <C-]> :NERDTreeVCS


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

" Use the below highlight group when displaying bad whitespace is desired
  highlight BadWhitespace ctermbg=red guibg=red

" Flag tabs instead of spaces
  au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/

" Flag Unnecessary Whitespace
  au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

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
  au FileType markdown set smartindent
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

" vim-airline
  let g:airline_theme = 'kolor'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'

" gitgutter
  if exists('&signcolumn')
    set signcolumn="yes"
  else
    let g:gitgutter_sign_column_always = 1
  endif

  let g:gitgutter_max_signs = 250

" LanguageClient-neovim
  let g:LanguageClient_serverCommands = {
        \ 'cpp': ['/usr/local/Cellar/cquery/20180718/bin/cquery',
        \ '--log-file=/tmp/cq.log',
        \ '--init={"cacheDirectory":"/tmp/cquery/",
        \                 "blacklist": ["./build", "./ext"]}'],
        \ 'ruby': ['~/.asdf/shims/solargraph', 'stdio'],
        \ 'python': ['~/.asdf/shims/pyls'],
        \ }
  let g:LanguageClient_autoStart = 1

" cscope
  if has("cscope")
    set csprg=/usr/local/bin/cscope
    set csto=0
    set cst
    set nocsverb
    if filereadable("cscope.out")
      cs add cscope.out
    elseif $CSOPE_DB != ""
      cs add $CSCOPE_DB
    endif
  endif

" vim-fugitive
  map <leader>gs :Gstatus<cr>
  map <leader>gc :Gcommit<cr>
  map <leader>gl :Glog<cr>

" config helpers
  command! InitEdit :e ~/.config/nvim/init.vim
  command! InitSource :source ~/.config/nvim/init.vim

" project level customization
  let g:project_file_name = 'project.vim'
  if !empty(glob(expand(g:project_file_name)))
    exec 'source' fnameescape(g:project_file_name)
  endif

" Rainbows!
  let g:rainbow_active = 1

" Auto indent pasted text
  nnoremap p p=`]<C-o>
  nnoremap P P=`]<C-o>

" Toggle paste mode (F2)
  set pastetoggle=<F2>

" Write a file with sudo (w!!)
  cmap w!! W !sudo tee % >/dev/null

" Use kj for escape
  inoremap kj <Esc>

" Folds
  set foldmethod=indent   "fold based on indent
  set foldnestmax=3       "deepest fold is 3 levels
  set nofoldenable        "don't fold by default
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

" Toggle relative line numbers (Ctrl+n)
  function! g:ToggleNuMode()
    if &nu == 1
      set rnu
    else
      set nu
    endif
  endfunction
  nnoremap <silent><C-n> :call g:ToggleNuMode()<cr>

" Paste from system clipboard in insert mode (Ctrl+v)
  imap <C-V> <ESC>"+gpa


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

""""""""
" Mutt "
""""""""

" Set the filetype on neomutt buffers
au BufRead /tmp/*mutt* setfiletype mail

" Delete quoted signatures.
au BufRead /tmp/*mutt* normal :g/^\(> \)--\s*$/,/^$/-1d/^$

"" COC settings

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
