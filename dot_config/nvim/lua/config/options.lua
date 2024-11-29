-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.scrolloff = 10
vim.o.sidescrolloff = 12
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300

-- listchars
vim.o.list = false
vim.opt.listchars:append({
  space = "·",
  trail = "~",
  tab = "│·",
})

vim.opt.swapfile = false
