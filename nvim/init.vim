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
" Neoformat for formatting
Plug 'sbdchd/neoformat'
" Auto commenting
Plug 'numToStr/Comment.nvim'
" Cursor smear effect
Plug 'sphamba/smear-cursor.nvim'

" Mason: Portable package manager for Neovim
Plug 'williamboman/mason.nvim'

" Mason LSPConfig: Bridges mason.nvim with nvim-lspconfig
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'


call plug#end()

lua require('Comment').setup()
lua require('smear_cursor').enabled = true

lua << EOF
-- Setup mason.nvim
require("mason").setup()

-- Setup mason-lspconfig with desired servers
require("mason-lspconfig").setup({
  ensure_installed = {"clangd", "lua_ls" },
})

-- Setup nvim-cmp with vsnip and LSP support
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- Use vsnip for snippets
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { "i", "s" }),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Optional: Enable completion in command mode (/, ?, :)
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Setup LSP capabilities for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Example: Replace or duplicate for each LSP server you use
require('lspconfig')['pyright'].setup {
  capabilities = capabilities
}
EOF



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

" Clipboard: Use system clipboard
:set clipboard=unnamedplus

" 마우스 활성화
set mouse=a



" Paste toggle with F1
" 'invpaste' toggles paste option, 'paste?' shows current paste state in cmdline
nnoremap <F1> :set invpaste paste?<CR>


nnoremap <F2> :NERDTreeToggle<CR>


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

" Set d as delete. Cutting is 'x'
" Normal mode: <leader>d
nnoremap <leader>d "_d

" Visual mode: <leader>d
vnoremap <leader>d "_d

inoremap jk <Esc>
nnoremap w <C-w>w
inoremap <C-v> <C-r><C-o>+
