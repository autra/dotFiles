-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--

-- NOTE: on nixos, we already have an isolated python for lvim.
-- So I *probably* need this on other oses?
-- vim.g.python3_host_prog="~/.venvs/nvim/bin/python"
-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
  "bash",
  "nix",
}
lvim.builtin.treesitter.context_commentstring = { enable = true }

lvim.plugins = {
 -- { "lunarvim/colorschemes" },
  { "ap/vim-css-color"},
  -- { "chriskempson/base16-vim" },
  { dir = "~/repos/base16-vim"},
  { "tpope/vim-abolish" },
  { "tpope/vim-fugitive" },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { "mfussenegger/nvim-ansible" },
  {
    "EthanJWright/vs-tasks.nvim",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- vim.fn.json_decode does not support json5 yet
      {
        'Joakker/lua-json5',
        build = './install.sh'
      }
    },
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<leader>m", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
    },
    config = true,
  },
  { "mfussenegger/nvim-dap-python" },
  { "puremourning/vimspector" },
  -- testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },
  { "nvim-neotest/neotest-python" },
  { "andythigpen/nvim-coverage" },
}
lvim.builtin.dap.active = true
require('dap-python').setup('~/.venvs/debugpy/bin/python')

-- colors !!
-- lvim.colorscheme = "base16-github"
-- require("themes.kantix").load_syntax()
-- lvim.colorscheme = "base16-gruvbox-dark-hard"
lvim.colorscheme = "base16-kantix"

-- vim.opt.background="dark"
vim.opt.background="light"
vim.opt.wrap=true

-- lualine
-- local custom_ppl = require'lualine.themes.papercolor_light'
-- custom_ppl.normal.c.bg = '#183691'
-- custom_ppl.normal.b.bg = '#0086b5'
-- lvim.builtin.lualine.options.theme = custom_ppl
lvim.builtin.lualine.options.theme = "base16"
-- require('lualine').setup {
--   options = { theme  = custom_ppl }
-- }

-- key bindings
lvim.keys.normal_mode["<Leader><TAB>"] = ":e #<Enter>"
lvim.keys.normal_mode["<C-p>"] = "<cmd>Telescope git_files<CR>"
lvim.builtin.terminal.open_mapping = "<C-t>"
-- lvim.keys.normal_mode["<C-p>"] = lvim.lsp.buffer_mappings.normal_mode['<Leader>f']
lvim.builtin.which_key.mappings["t"] = {
  name = "This file",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { ":copen<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}
lvim.builtin.telescope.pickers = {
  find_files = {
    layout_config = {
      width = 0.95,
      height = 0.95,
    },
  },
  git_files = {
    layout_config = {
      width = 0.95,
      height = 0.6,
    },
  },
  grep_string = {
    layout_config = {
      width = 0.95,
      height = 0.95,
    },
  },
  live_grep = {
    layout_config = {
      width = 0.95,
    },
  },
}

-- plugin config
require("vstask").setup({
  terminal = 'toggleterm',
  term_opts = {
    vertical = {
      direction = "vertical",
      size = "80"
    },
    horizontal = {
      direction = "horizontal",
      size = "10"
    },
    current = {
      direction = "float",
    },
    tab = {
      direction = 'tab',
    }
  },
  json_parser = require('json5').parse
})

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "prettier", filetypes = { "html", "css", "less", "sass", "typescript", "typescriptreact", "javascript", "javascriptreact", "vue", "yaml" }},
  { command = "black", filetypes = { "python" }},
  { command = "isort", filetypes = { "python" }},
  { command = "nixpkgs-fmt", filetypes = { "nix" }},
  -- { command = "rustfmt", filetype = { "rust" }},
  -- { command = "sqlfluff", filetypes = { "sql" }}
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
   command = "sqlfluff",
   filetypes = {"sql"},
   extra_args = {"--dialect", "postgres"}
  },
  { 
    command = "mypy", 
    filetypes = { "python" },
    extra_args = { "--follow-imports=silent" },
  },
}

-- language servers setup
-- TODO does not work?
lvim.lsp.installer.setup.automatic_installation = {
  exclude = {}
}
require'lspconfig'.ansiblels.setup{}
require'lspconfig'.ts_ls.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.sqls.setup{}
require'lspconfig'.volar.setup{}
-- require'lspconfig'.pylsp.setup{
--   configurationSources = {"flake8"},
--   plugins = {
--     flake8 = {
--       enabled = false,
--     },
-- --     pylsp_mypy = { enabled = true },
--     pycodestyle = { enabled = false },
--   }
-- }
require'lspconfig'.pyright.setup{}
require'lspconfig'.mypy.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.rnix.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.solargraph.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.remark_ls.setup{}
require'lspconfig'.ruby_lsp.setup{}

-- config
vim.g.coloresque_extra_filetypes = { "nix" }

-- tests
require("neotest").setup({
  adapters = {
    require("neotest-python")
  }
})
require("coverage").setup()


-- lvim.builtin.which_key.mappings["tt"] = { "<cmd>lua require(\"neotest\").run.run()<cr>", "Run nearest test" }
-- lvim.builtin.which_key.mappings["tT"] = { "<cmd>lua require(\"neotest\").run.run(vim.fn.expand(\"%\"))<cr>", "Run current file tests" }
-- lvim.builtin.which_key.mappings["tc"] = { "<cmd>Coverage<cr>", "Display test coverage" }
lvim.builtin.which_key.mappings["t"] = {
  -- name = "+test",
  t = { "<cmd>lua require(\"neotest\").run.run()<cr>", "Run nearest test" },
  T = { "<cmd>lua require(\"neotest\").run.run(vim.fn.expand(\"%\"))<cr>", "Run current file tests" },
  c = { "<cmd>Coverage<cr>", "Display test coverage" },
}
