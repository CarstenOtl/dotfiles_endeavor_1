" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')
  " Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
" Plug 'ycm-core/YouCompleteMe'

  Plug 'christoomey/vim-tmux-navigator'

  " Plug 'dense-analysis/ale'

  Plug 'junegunn/vim-easy-align'

  Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }

  " Git for NERDTree
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

  " syntax highlighting for NERDTree
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }

  Plug 'mattn/emmet-vim'

  Plug 'vim-airline/vim-airline'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'tpope/vim-fugitive'

  Plug 'tpope/vim-commentary'

  Plug 'tpope/vim-surround'

  Plug 'sheerun/vim-polyglot'

  Plug 'vim-ctrlspace/vim-ctrlspace'

  Plug 'edkolev/tmuxline.vim'

  "some colorschemes
  Plug 'joshdick/onedark.vim'
  Plug 'ghifarit53/tokyonight-vim'

  "intelliSense engine
  " Plug 'neoclide/coc.nvim'

  "debugger
  Plug 'vim-vdebug/vdebug' "python, ruby, php....

  " Icons for NERDTree
  Plug 'ryanoasis/vim-devicons'

call plug#end()


" }}}

" Enable mouse support
set mouse=a

" Colorscheme
" set background=dark
" colorscheme tokyonight
colorscheme onedark

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" set clipboard copy-paste on
set clipboard+=unnamed

" set font
set guifont=Hack\ Nerd\ Font\ Mono:h11
" encoding
set encoding=utf-8

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number relativenumber

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Auto indentation
set autoindent

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=2

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set wrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Fold method
set foldmethod=marker

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=100

" listchars
set list
set listchars=space:·,trail:•,nbsp:␣

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" control space settings
set hidden
let g:ctrlspace_default_mapping_key = "<C-space> "

" MAPPINGS --------------------------------------------------------------- {{{

let mapleader = "\\" " set leader key to backslash

" Mappings code goes here.
" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" get rid of trailing whitespace
nnoremap <leader>rt :%s/\s\+$//e<CR>

" toggle NERDTree
" nnoremap <leader>nt :NERDTreeToggle<CR>
" toggle NERDTree with Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>

" switch between buffers
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>
" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Status bar code goes here.
let g:airline_detect_spell=1
let g:airline_detect_modified=1
let g:airline_detect_paste=1

" styling
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
" let g:airline_symbols.maxlinenr = '☰ '
" let g:airline_symbols.linenr = ''
" let g:airline_symbols.colnr = ''

" sections
let g:airline_section_z = '%l/%L%{g:airline_symbols.maxlinenr}%c'

""""""""""""""""""""" Extensions """""""""""""""""""""
" enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#airline_left_sep = ' '
let g:airline#extensions#tabline#airline_right_sep = ' '
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" }}}
