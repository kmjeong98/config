-- ============================================================
-- Neovim Configuration
-- ============================================================

-- Auto-install vim-plug if not present
local data_dir = vim.fn.stdpath('data') .. '/site'
if vim.fn.empty(vim.fn.glob(data_dir .. '/autoload/plug.vim')) == 1 then
  vim.fn.system({'curl', '-fLo', data_dir .. '/autoload/plug.vim', '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'})
  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    command = 'PlugInstall --sync | source $MYVIMRC',
  })
end

-- ============================================================
-- Plugins
-- ============================================================
local plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')

-- File Explorer
plug('preservim/nerdtree')

-- GitHub Copilot (requires Node.js 17+)
plug('github/copilot.vim')

-- Syntax highlighting
plug('sheerun/vim-polyglot')

-- Catppuccin Theme
plug('catppuccin/nvim', { as = 'catppuccin' })

vim.call('plug#end')

-- ============================================================
-- General Settings
-- ============================================================
local opt = vim.opt

-- Enable mouse in all modes
opt.mouse = 'a'

-- Line numbers
opt.number = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.cursorline = true
opt.signcolumn = 'yes'
opt.scrolloff = 8
opt.wrap = true
opt.showtabline = 2

-- Encoding
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-- Backup and swap
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Clipboard (use system clipboard)
opt.clipboard = 'unnamedplus'

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Update time for faster response
opt.updatetime = 300

-- ============================================================
-- Key Mappings
-- ============================================================
local map = vim.keymap.set

-- Leader key
vim.g.mapleader = ' '

-- Exit insert mode with jk
map('i', 'jk', '<Esc>', { noremap = true })

-- NERDTree toggle with Ctrl+n
map('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true })

-- NERDTree find current file
map('n', '<leader>nf', ':NERDTreeFind<CR>', { noremap = true })

-- Clear search highlight with Escape
map('n', '<Esc>', ':nohlsearch<CR>', { noremap = true })

-- Better window navigation
map('n', '<C-h>', '<C-w>h', { noremap = true })
map('n', '<C-j>', '<C-w>j', { noremap = true })
map('n', '<C-k>', '<C-w>k', { noremap = true })
map('n', '<C-l>', '<C-w>l', { noremap = true })

-- Resize windows with arrows
map('n', '<C-Up>', ':resize +2<CR>', { noremap = true })
map('n', '<C-Down>', ':resize -2<CR>', { noremap = true })
map('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true })
map('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true })

-- Move lines up/down in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true })
map('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true })

-- Stay in visual mode after indenting
map('v', '<', '<gv', { noremap = true })
map('v', '>', '>gv', { noremap = true })

-- Terminal mode: Esc to return to normal mode
map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

-- Quick save and quit
map('n', '<leader>w', ':w<CR>', { noremap = true })
map('n', '<leader>q', ':q<CR>', { noremap = true })

-- Buffer navigation
map('n', '<leader>bn', ':bnext<CR>', { noremap = true })
map('n', '<leader>bp', ':bprevious<CR>', { noremap = true })
map('n', '<leader>bd', ':bdelete<CR>', { noremap = true })

-- Tab navigation
map('n', '<leader>tn', ':tabnew<CR>', { noremap = true })
map('n', '<leader>tc', ':tabclose<CR>', { noremap = true })
map('n', 'gt', ':tabnext<CR>', { noremap = true })
map('n', 'gT', ':tabprevious<CR>', { noremap = true })
map('n', '<leader>1', '1gt', { noremap = true })
map('n', '<leader>2', '2gt', { noremap = true })
map('n', '<leader>3', '3gt', { noremap = true })
map('n', '<leader>4', '4gt', { noremap = true })
map('n', '<leader>5', '5gt', { noremap = true })

-- ============================================================
-- NERDTree Settings
-- ============================================================

-- Show hidden files
vim.g.NERDTreeShowHidden = 1

-- Keep NERDTree open when opening a file
vim.g.NERDTreeQuitOnOpen = 0

-- Ignore certain files
vim.g.NERDTreeIgnore = { '\\.git$', '\\.DS_Store', '__pycache__', '\\.pyc$' }

-- Auto-open NERDTree when starting nvim
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  command = 'NERDTree | wincmd p',
})

-- Tab key in NERDTree acts as 'go' (open file, keep cursor in NERDTree)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'nerdtree',
  callback = function()
    vim.keymap.set('n', '<Tab>', 'go', { buffer = true, silent = true, remap = true })
  end,
})

-- Auto-close vim if NERDTree is the only window left
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  command = "if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif",
})

-- ============================================================
-- Copilot Settings
-- ============================================================
-- Copilot key mappings (defaults work well)
-- Tab: Accept suggestion
-- Ctrl+]: Dismiss suggestion
-- Alt+]: Next suggestion
-- Alt+[: Previous suggestion

-- ============================================================
-- Colorscheme
-- ============================================================
require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  transparent_background = false,
  term_colors = true,
})

vim.cmd.colorscheme('catppuccin')
