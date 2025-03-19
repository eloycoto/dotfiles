
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
    'L3MON4D3/LuaSnip',
    'ctrlpvim/ctrlp.vim',
    'gelguy/wilder.nvim',
    'gruvbox-community/gruvbox',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
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
    "nvim-tree/nvim-web-devicons",
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      build = "make",
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    }
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


-- vim.o.colorscheme=gruvbox
vim.g.gruvbox_contrast_dark = "soft"
vim.g.gruvbox_contrast_light = "soft"
vim.cmd("colorscheme gruvbox")

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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt.equalalways = true
        vim.opt.winwidth = 100
        vim.opt_local.columns = 80
        vim.opt_local.textwidth = 80
        vim.opt_local.wrap = true
    end
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
      {
        function()
          return require("avante.config").provider
        end,
      },
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

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
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

vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.go", "*.rs"},
    callback = function()
        -- vim.lsp.buf.code_action()
        -- vim.lsp.buf.format({async = true})
    end,
})

if vim.fn.executable('ltext') > 0 then
    nvim_lsp["ltext"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "ltex-ls" },
        filetypes = { "markdown", "text" },
        flags = { debounce_text_changes = 300 }
    }
end


require('gitsigns').setup()

local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})

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

-- Small utility to be able to add VISIBILITY to the recurrent nodes.
vim.api.nvim_exec([[
    augroup OrgFileOpenedAutocmd
        autocmd!
        autocmd BufReadPost *.org lua require("orgmode-custom").VISIBILITY()
    augroup END
]], false)


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


--------------------
-- Avante
--------------------
avante_config = {
    provider = "ollama",
    ollama = {
        model = "qwen2.5-coder:7b",
        endpoint = os.getenv("OLLAMA_ENDPOINT"),
    },
    vendors = {
        llama = {
            provider = "ollama",
            model = "llama3.1:8b",
            endpoint = os.getenv("OLLAMA_ENDPOINT"),
        },
        ["claude-haiku"] = {
            __inherited_from = "claude",
            model = "claude-3-haiku-20241022",
            timeout = 30000,
            temperature = 0,
            max_tokens = 8000,
        },
    },

    dual_boost = {
        enabled = false,
        first_provider = "ollama",
        second_provider = "llama",
        prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
        timeout = 60000, -- Timeout in milliseconds
      },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = "center", -- left, center, right for title
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          border = "rounded",
          start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = true, -- Start insert mode when opening the ask window
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "ours", -- which diff to focus after applying
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
        --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --- Disable by setting to -1.
        override_timeoutlen = 500,
      }
}

vim.api.nvim_create_user_command('Llama', function()
    require("avante.api").switch_provider("llama")
end, {})

vim.api.nvim_create_user_command('Claude', function()
    require("avante.api").switch_provider("claude")
end, {})

require('avante_lib').load()
require("avante").setup(avante_config)
