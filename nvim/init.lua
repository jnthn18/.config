require("jmore.core")

vim.pack.add({
  { src = "https://github.com/rose-pine/neovim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range('*') },
})

local default_color = "rose-pine"
vim.cmd("colorscheme " .. default_color)

require("mason").setup()
require("blink.cmp").setup()

vim.lsp.enable({"lua_ls","css-lsp","css-variables-language-server","tsgo"})
