function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
    'hrsh7th/cmp-buffer',
    'L3MON4D3/LuaSnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
    'ctrlpvim/ctrlp.vim',
    'gruvbox-community/gruvbox',
    'hrsh7th/nvim-cmp',
    'lewis6991/gitsigns.nvim',
    'liuchengxu/vista.vim',
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    'nvim-orgmode/orgmode',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter',
    'rust-lang/rust.vim',
    'ryanoasis/vim-devicons',
    'sirtaj/vim-openscad',
    'tpope/vim-commentary',
    'codota/tabnine-nvim',
    'onsails/lspkind.nvim',
    'nvim-lualine/lualine.nvim',
    'akinsho/org-bullets.nvim',
}
require("lazy").setup(plugins)

vim.g.mapleader = ","
vim.g.foldlevel = 2
vim.opt.foldlevel = 3
vim.opt.conceallevel = 3

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'
vim.opt.termguicolors =  true
vim.o.nocompatible = true
vim.opt.syntax = "on"
vim.opt.cursorline = true
vim.opt.showmode = true
vim.opt.history = 1000
vim.opt.undolevels = 100
vim.opt.ruler=true
vim.o.number=true
vim.opt.ic = true
vim.opt.splitbelow = true
vim.opt.splitright  = true
vim.opt.laststatus = 2
vim.opt.hidden = true
vim.opt.cmdheight = 3
vim.opt.updatetime = 300
vim.opt.so = 3
vim.opt.termguicolors = true
vim.o.nobackup = true
vim.o.nowb = true
vim.opt.background = light
vim.opt.completeopt="menuone,noinsert,noselect"

vim.api.nvim_command("set noswapfile")

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.clipboard = "unnamedplus"

vim.opt.colorcolumn = "80"
vim.o.colorscheme=gruvbox
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_contrast_light = "hard"
vim.cmd("colorscheme gruvbox")

vim.g.rustfmt_autosave = 1


vim.opt.guitablabel="%M%t"
map('n', '<C-t>', ':tabnew<CR>')
map('n', '<C-m>', ':tabnext<CR>')
map('n', '<C-k>', ':tabprevious<CR>')
map('n', '<leader><leader>', ':tabnext<CR>')

map('n', 'f', ':Telescope grep_string<CR>')

map('n', '<UP>', '<Nop>')
map('n', '<DOWN>', '<Nop>')
map('n', '<LEFT>', '<Nop>')
map('n', '<RIGHT>', '<Nop>')

map('x', '<Leader>', '<Plug>Commentary')

map('v', '<leader>s', ':sort')
map('v', '<', '<gv')
map('v', '>', '>gv')
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '>-2<CR>gv=gv")
map('n', 'gx', ":m '>-2<CR>gv=gv")

map("n", "gx", ":silent !xdg-open <cfile><CR>")

vim.cmd([[
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
    highlight Comment cterm=italic gui=italic
    autocmd FileType org setlocal tabstop=2 shiftwidth=2
]])

vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.go"},
    callback = function()
        vim.lsp.buf.code_action()
        vim.lsp.buf.format({async = true})
    end,
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path=1}},
    lualine_x = {'encoding', 'fileformat', 'filetype', 'tabnine'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


require('tabnine').setup({
  disable_auto_comment=false,
  accept_keymap="<Tab>",
  debounce_ms = 300,
  dismiss_keymap = "<C-]>",
  suggestion_color = {gui = "#9fc5e8", cterm = 200}
})

local lspkind = require('lspkind')

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	path = "[Path]",
}

local log = function(message)
    local log_file_path = '/tmp/nvim.log'
    local log_file = io.open(log_file_path, "a")
    io.output(log_file)
    io.write(message.."\n")
    io.close(log_file)
end

local globaln = 0 

local cmp = require'cmp'
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
		-- { name = 'cmp_tabnine' },
        { name = 'nvim_lsp' },
        { name = 'orgmode' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
    }),
    formatting = {
		format = function(entry, vim_item)
			-- if you have lspkind installed, you can use it like
			-- in the following line:
	 		vim_item.kind = lspkind.symbolic(vim_item.kind, {mode = "symbol"})
	 		vim_item.menu = source_mapping[entry.source.name]
	 		local maxwidth = 80
	 		vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
	 		return vim_item
	  end,
	},
    experimental = {
        -- ghost_text = true
    }
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.g.ctrlp_map = '<c-p>'
vim.g.ctrlp_working_path_mode = 'ra'
vim.g.ctrlp_switch_buffer = 'et'
vim.g.ctrlp_mruf_max=450
vim.g.ctrlp_max_files=0
vim.g.ctrlp_use_caching = 1
vim.g.ctrlp_clear_cache_on_exit = 0
vim.g.ctrlp_match_window = 'bottom,order:btt,max:10,results:10'
vim.g.ctrlp_buftag_types = {
	go= "--language-force=go --golang-types=ftv"
}

local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- LSP Buffer Mappings.
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, bufopts)
  vim.keymap.set("n", "<leader>d",vim.diagnostic.open_float, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- require'lspconfig'.rust_analyzer.setup{}
local servers = { "gopls", "rust_analyzer" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

require('gitsigns').setup()

---------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------
require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {'org'},
        additional_vim_regex_highlighting = {'org'},
    },
    ensure_installed = {'org'}, -- Or run :TSUpdate org
    }

require('orgmode').setup({
    org_agenda_files = {'~/notes/*'},
    org_default_notes_file = '~/notes/refile.org',
})

require('org-bullets').setup()

---------------------------------------------------------------------
-- Custom funcions
---------------------------------------------------------------------
function ack(opts)
    local search = vim.fn.expand('<cword>')
    print(#opts.fargs)
    if opts and #opts.fargs > 0 then
        search = table.concat(opts.fargs, " ")
    end
    require('telescope.builtin').live_grep({
        default_text = search,
        use_regex = true
    })
end

vim.api.nvim_create_user_command(
  'Ack',
  ack,
  {bang = true, nargs="*"}
)
