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
    'folke/zen-mode.nvim',
    'gelguy/wilder.nvim',
    -- 'gruvbox-community/gruvbox',
    'ellisonleao/gruvbox.nvim',
    'lewis6991/gitsigns.nvim',
    'liuchengxu/vista.vim', --Tagbar
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lualine/lualine.nvim',
    'nvim-orgmode/orgmode',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
    'onsails/lspkind.nvim',
    'rust-lang/rust.vim',
    'ryanoasis/vim-devicons',
    'sirtaj/vim-openscad',
    'tpope/vim-commentary',
    'RRethy/vim-illuminate',
    'folke/trouble.nvim',
    "nvim-tree/nvim-web-devicons",
    'rafamadriz/friendly-snippets',
    {'saghen/blink.cmp', version = '1.*' },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
}
require("lazy").setup(plugins)

vim.g.mapleader = ","
vim.g.foldlevel = 2

vim.opt.background="light"
vim.opt.cmdheight = 3
vim.opt.colorcolumn = "80"
vim.opt.completeopt="menuone,noinsert,noselect"
vim.opt.concealcursor = 'nc'
vim.opt.conceallevel = 2
vim.opt.conceallevel = 3
vim.opt.cursorline = true
vim.opt.foldlevel = 3
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.formatoptions = "cqjw"
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.ic = true
vim.opt.lazyredraw = true
vim.opt.ruler=true
vim.opt.showmode = true
vim.opt.so = 3
vim.opt.splitbelow = true
vim.opt.splitright  = true
vim.opt.synmaxcol = 240
vim.opt.syntax = "on"
vim.opt.termguicolors =  true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undolevels = 100
vim.opt.updatetime = 250

vim.api.nvim_command("set noswapfile")
vim.api.nvim_command("set modifiable")

vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.laststatus = 3
vim.o.number=true
vim.o.shiftwidth = 4
vim.o.tabstop = 4


vim.cmd.colorscheme("gruvbox")

vim.g.rustfmt_autosave = 1


-- vim.opt.guitablabel="%M%t"
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
    autocmd FileType nix setlocal tabstop=2 shiftwidth=2
]])

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
    globalstatus = vim.go.laststatus == 3,
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
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype'
    },
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

---------------------------------------
-- Vista
---------------------------------------
vim.api.nvim_create_user_command('Tagbar', ":Vista", {})

require('illuminate').configure({
    providers = {
        'lsp',
        -- 'treesitter',
        'regex',
    },
    delay = 500,
    filetype_overrides = {},
    filetypes_denylist = {
        'dirbuf',
        'dirvish',
        'fugitive',
    },
    filetypes_allowlist = {},
    modes_denylist = {},
    modes_allowlist = {},
    providers_regex_syntax_denylist = {},
    providers_regex_syntax_allowlist = {},
    under_cursor = true,
    large_file_cutoff = nil,
    large_file_overrides = nil,
    min_count_to_highlight = 1,
    should_enable = function(bufnr) return true end,
    case_insensitive_regex = false,
})


local lspkind = require('lspkind')

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

local servers = { "gopls", "rust_analyzer", "harper_ls" }
for _, lsp in ipairs(servers) do
  if lsp == "harper_ls" then
      nvim_lsp[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "markdown", "text", "org", "mail" },
          settings = {
              ["harper-ls"] = {
                  linters = {
                    spell_check = true,
                    spelled_numbers = false,
                    an_a = true,
                    sentence_capitalization = true,
                    unclosed_quotes = true,
                    wrong_quotes = true,
                    long_sentences = true,
                    repeated_words = true,
                    matcher = true,
                    spaces = false,
                  }
              }
          }
      }
  else
      nvim_lsp[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities
      }
  end
end


vim.diagnostic.config({
  float = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',
    prefix = ' ',
    scope = 'cursor',
  },
})

-- Auto-show diagnostic float after 500ms
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})


require('blink.cmp').setup({
    keymap = { preset = 'super-tab' },

    appearance = {
        nerd_font_variant = 'mono'
    },

    completion = { documentation = { auto_show = false } },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" }
})

require('gitsigns').setup()

local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})

-- Add the autocmd to that group
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.org",
  callback = function()
    -- This is better for harper.
    vim.bo.expandtab = false
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2

    -- PR: https://github.com/nvim-orgmode/orgmode/pull/965
    vim.api.nvim_set_hl(0, '@org.hyperlink', { link = '@markup.link.url' })
    vim.api.nvim_set_hl(0, '@org.hyperlink.url', { link = '@org.hyperlink' })
    vim.api.nvim_set_hl(0, '@org.hyperlink.desc', { link = '@org.hyperlink' })
    require("orgmode-custom").VISIBILITY()
  end,
})

---------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------
-- Tree-sitter configuration
require('orgmode').setup({
    org_agenda_files = {'~/notes/*'},
    org_default_notes_file = '~/notes/refile.org',
    mappings = {
        org = {
            org_do_demote="<leader><",
            org_do_promote="<leader>>",
        }
    }
})

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



---------------------------------------------------------------------
-- Termdebug funcions
---------------------------------------------------------------------

-- cargo_build_debug Build the cargo crate, and return the executables path
function cargo_build_debug()
    vim.cmd("!cargo build")
    local cargo_output = vim.fn.system("cargo build --message-format=json 2> /dev/null | jq -r -s  '[.[] | select(.executable !=null) | .executable'] | sort")
    return vim.fn.json_decode(cargo_output)
end

function Debugger()
    vim.cmd('packadd termdebug')

    vim.g.termdebug_wide = 80
    -- let g:termdebug_wide=1
    local filepaths = cargo_build_debug()
    local paths_len = #filepaths
    local path = ""
    if paths_len == 0 then
        error("executable cannot be found")
    elseif paths_len == 1 then
        path = filepaths[1]
    else
        local choice = vim.fn.inputlist(filepaths)
        path = filepaths[choice+1]
    end

    local options = {"custom.gdb", "openocd.gdb"}
    for _, option in ipairs(options) do
        local stat = vim.loop.fs_stat(option)
        if stat then
            path = "-x " .. option .. " " .. path
        end
    end

    vim.cmd('Termdebug '..path)
end

vim.api.nvim_create_user_command('DDebug', Debugger, {})

--------------------
-- Ellm functions
--------------------
ellm = require("llm").new()
vim.api.nvim_command('command! -range LLM lua ellm:call_function()')


require("trouble").setup({
  position = "bottom",
  height = 10,
  auto_open = false,
})
map('n', '<leader>x', '<cmd>Trouble diagnostics toggle<cr>')

