-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if not vim.g.vscode then
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.cmd("colorscheme nightfox")
  vim.cmd("set guifont=Iosevka:17")
end