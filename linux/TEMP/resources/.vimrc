" ===================================================
" Plugins Begin
" ===================================================

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'itchyny/lightline.vim'
Plug 'stephpy/vim-yaml'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdtree'

" Color Schemes
Plug 'junegunn/seoul256.vim'
Plug 'flazz/vim-colorschemes'
Plug 'sjl/badwolf'

call plug#end()

" ===================================================
" Theme
" ===================================================

colo badwolf

" ===================================================
" Basic Settings Begin
" ===================================================

set nu
set autoindent
set smartindent
set lazyredraw
set visualbell
set backspace=indent,eol,start
set incsearch
set ignorecase smartcase
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set scrolloff=5
set encoding=utf-8
set list
set listchars=tab:\|\ ,
set virtualedit=block
set nojoinspaces
set diffopt=filler,vertical
set autoread
set clipboard=unnamed
set grepformat=%f:%l:%c:%m,%f:%l:%m
set completeopt=menuone,preview
silent! set cryptmethod=blowfish2

set formatoptions+=1

if has('patch-7.3.541')
  set formatoptions+=j
endif

if has('patch-7.4.338')
  let &showbreak = 'â†³ '
  set breakindent
  set breakindentopt=sbr
endif

" ===================================================
" Vim Indent Guides
" ===================================================

let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1

" ===================================================
" Status Line
" ===================================================

set noshowmode
set noruler
set laststatus=2
set noshowcmd

let g:lightline = { 'colorscheme': 'powerline',}

" ===================================================
" Temp Files
" ===================================================

set backupdir=/tmp//,.
set directory=/tmp//,.
set undodir=/tmp//,.

" ===================================================
" Mouse
" ===================================================

silent! set ttymouse=xterm2
set mouse=a

" ===================================================
" Mappings
" ===================================================

map <C-o> :NERDTreeToggle<CR>