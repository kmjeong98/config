" ============================================================
" Neovim Configuration
" ============================================================

" Auto-install vim-plug if not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ============================================================
" Plugins
" ============================================================
call plug#begin(stdpath('data') . '/plugged')

" File Explorer
Plug 'preservim/nerdtree'

" GitHub Copilot (requires Node.js 17+)
Plug 'github/copilot.vim'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

call plug#end()

" ============================================================
" General Settings
" ============================================================

" Enable mouse in all modes
set mouse=a

" Line numbers
set number

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Appearance
set cursorline
set signcolumn=yes
set scrolloff=8
set wrap
set showtabline=2

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Backup and swap
set nobackup
set nowritebackup
set noswapfile

" Clipboard (use system clipboard)
set clipboard=unnamedplus

" Split behavior
set splitright
set splitbelow

" Update time for faster response
set updatetime=300


" ============================================================
" Key Mappings
" ============================================================

" Leader key
let mapleader = " "

" Exit insert mode with jk
inoremap jk <Esc>

" NERDTree toggle with Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>

" NERDTree find current file
nnoremap <leader>nf :NERDTreeFind<CR>

" Clear search highlight with Escape
nnoremap <Esc> :nohlsearch<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows with arrows
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Move lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Stay in visual mode after indenting
vnoremap < <gv
vnoremap > >gv

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Tab navigation
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap gt :tabnext<CR>
nnoremap gT :tabprevious<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

" ============================================================
" NERDTree Settings
" ============================================================

" Show hidden files
let NERDTreeShowHidden=1

" Keep NERDTree open when opening a file
let NERDTreeQuitOnOpen=0

" Ignore certain files
let NERDTreeIgnore=['\.git$', '\.DS_Store', '__pycache__', '\.pyc$']

" Auto-open NERDTree when starting nvim
autocmd VimEnter * NERDTree | wincmd p

" Auto-close vim if NERDTree is the only window left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


" ============================================================
" Copilot Settings
" ============================================================
" Copilot key mappings (defaults work well)
" Tab: Accept suggestion
" Ctrl+]: Dismiss suggestion
" Alt+]: Next suggestion
" Alt+[: Previous suggestion
