-- :fennel:1714651605
local vim = _G.vim
do
  local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "--single-branch", "https://github.com/folke/lazy.nvim.git", lazypath})
  else
  end
  do end (vim.opt.runtimepath):prepend(lazypath)
end
local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.completeopt = "menuone,noselect"
vim.o.laststatus = 3
vim.o.cursorline = 1
vim.o.tabstop = 4
vim.o.shiftwidth = 4
map("n", "<Space>", "<Nop>", {silent = true})
map("n", "k", "v:count == 0 ? 'gk' : 'k'", {expr = true, silent = true})
map("n", "j", "v:count == 0 ? 'gj' : 'j'", {expr = true, silent = true})
map("n", "q", "<Nop>", {silent = true})
map("v", "x", "'d'", {expr = true, silent = true})
map("n", "<leader>1", vim.diagnostic.goto_prev, {desc = "Go to previous diagnostic"})
map("n", "<leader>2", vim.diagnostic.goto_next, {desc = "Go to next diagnostic"})
map("n", "<leader>k", vim.diagnostic.open_float, {desc = "Float diagnostic"})
map("n", "<leader>q", vim.diagnostic.setloclist, {desc = "Open diagnostic list"})
map("n", "<S-h>", "<C-o>", {noremap = true, silent = true})
map("n", "<S-l>", "<C-i>", {noremap = true, silent = true})
map("n", "<leader>w", "viw", {noremap = true, silent = true})
vim.cmd("set clipboard+=unnamedplus")
local function _2_()
  local cd = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":t")
  return vim.api.nvim_command(("silent !tmux rename-window '" .. cd .. "'"))
end
_G.Rename_tmux_pane = _2_
vim.api.nvim_command("autocmd DirChanged * lua Rename_tmux_pane()")
local lazy = require("lazy")
return lazy.setup({{import = "plugins"}, {import = "plugins.themes"}, {import = "ftplugins"}, {"tpope/vim-sensible", "udayvir-singh/hibiscus.nvim", "udayvir-singh/tangerine.nvim"}})