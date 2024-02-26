-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--

vim.g.python3_host_prog="~/.venvs/nvim/bin/python"
vim.opt.background="light"

-- lualine
local custom_ppl = require'lualine.themes.papercolor_light'
custom_ppl.normal.c.bg = '#183691'
custom_ppl.normal.b.bg = '#0086b5'
lvim.builtin.lualine.options.theme = custom_ppl
-- lvim.builtin.lualine.options.theme = "papercolor_light"
-- require('lualine').setup {
--   options = { theme  = custom_ppl }
-- }

-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
}

lvim.plugins = {
 -- { "lunarvim/colorschemes" },
  { "chriskempson/base16-vim" },
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
}
lvim.colorscheme = "base16-github"
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
  { command = "prettier", filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" }},
  { command = "black", filetypes = { "python" }},
  { command = "isort", filetypes = { "python" }},
  -- { command = "sqlfluff", filetypes = { "sql" }}
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
   command = "sqlfluff",
   filetypes = {"sql"},
   extra_args = {"--dialect", "postgres"}
  },
  { name = "mypy" },
  -- { name = "flake8" },
}

-- language servers setup
require'lspconfig'.ansiblels.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.sqls.setup{}
require'lspconfig'.volar.setup{}
require'lspconfig'.pylsp.setup{
  configurationSources = {"flake8"},
  plugins = {
    flake8 = {
      enabled = true,
      maxLineLengh = 120,
		  ignore = "E501",
    },
    pylsp_mypy = { enabled = true },
    pycodestyle = { enabled = false },
  }
}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.nil_ls.setup{}
require'lspconfig'.clangd.setup{}

