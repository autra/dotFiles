-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.plugins = {
 -- { "lunarvim/colorschemes" },
  { "chriskempson/base16-vim" },
  { "tpope/vim-abolish" },
  { "tpope/vim-fugitive" },
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function ()
      vim.cmd ("let g:minimap_width = 10")
      vim.cmd ("let g:minimap_auto_start = 1")
      vim.cmd ("let g:minimap_auto_start_win_enter = 1")
      vim.cmd ("let g:minimap_git_colors = 1")
      vim.cmd ("let g:minimap_enable_highlight_colorgroup = 1")
      vim.cmd ("let g:minimap_highlight_search = 1")
    end,
  },
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
  }
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

-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "eslint", filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }}
-- }
require'lspconfig'.ansiblels.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.sqlls.setup{}
-- require'lspconfig'.pylsp.setup{}
