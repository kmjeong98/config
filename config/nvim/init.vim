" ---------------------------------------------
" ~/.config/nvim/init.vim
" ---------------------------------------------

" Use VIM Plug for plugin management
call plug#begin('~/.local/share/nvim/plugged')

" Gruvbox colorscheme
Plug 'morhetz/gruvbox'
" NERDTree
Plug 'preservim/nerdtree'
" Airline for status line
Plug 'vim-airline/vim-airline'
" Coc.nvim for autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Neoformat for formatting
Plug 'sbdchd/neoformat'
" Auto commenting
Plug 'numToStr/Comment.nvim'

call plug#end()

lua require('Comment').setup()

" Colorscheme settings
syntax on
set termguicolors
set background=dark
colorscheme gruvbox

" Enable line numbers
set number

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" 1) Auto-open NERDTree on Vim start
" 2) After opening, move focus to the 'next' window (the main file)
autocmd VimEnter * NERDTree | wincmd l

" NERDTree autoclose if it's the only buffer
" This autocommand checks if the only window is NERDTree, then quit Vim
autocmd BufEnter * if winnr('$') == 1 && getbufvar(winbufnr(0), "&filetype") ==# 'nerdtree' | quit | endif


" Clipboard: Use system clipboard
set clipboard=unnamedplus

" 마우스 활성화
set mouse=a


" Paste toggle with F1
" 'invpaste' toggles paste option, 'paste?' shows current paste state in cmdline
nnoremap <F1> :set invpaste paste?<CR>

" Use F3 to format (via Neoformat)
nnoremap <F3> :Neoformat<CR>

" Airline configuration (if desired)
let g:airline_powerline_fonts = 1

" Some recommended settings for better experience
set hidden           " Allow switching between buffers without saving
set expandtab        " Use spaces instead of tabs
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent

nnoremap <Tab> :wincmd w<CR>

vmap <LeftRelease> y

" Set d as delete. Cutting is 'x'
" Normal mode: <leader>d
nnoremap <leader>d "_d

" Visual mode: <leader>d
vnoremap <leader>d "_d

inoremap jk <Esc>

