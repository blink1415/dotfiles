-- Install Lazy
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
_G.vim = vim
vim.opt.rtp:prepend(lazypath)

-- Set the leader key for mappings to " "
vim.g.mapleader = " "

-- Set the local leader key for mappings to " "
vim.g.maplocalleader = " "

-- Disable highlighting search results
vim.o.hlsearch = false

-- Show line numbers in the current window
vim.wo.number = true

-- Enable mouse support in all modes
vim.o.mouse = "a"

-- Indent wrapped lines to the beginning of the next line
vim.o.breakindent = true

-- Enable persistent undo history
vim.o.undofile = true

-- Ignore case when searching, unless the pattern contains a capital letter
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set the update interval for external events, like CursorHold
vim.o.updatetime = 250

-- Show sign column for git changes, diagnostics, etc
vim.wo.signcolumn = "yes"

-- Enable true color support for terminals that support it
vim.o.termguicolors = true

-- Customize completion menu behavior
vim.o.completeopt = "menuone,noselect"

-- Set the number of status lines to display
vim.o.laststatus = 3

-- Enable cursorline
vim.o.cursorline = 1

-- Set tab size to 4 spaces
vim.o.tabstop = 4

vim.o.shiftwidth = 4

-- Hides commandline when not in use. Breaks when used with noice.nvim
-- vim.o.ch = 0

_G.map = vim.keymap.set
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "q", "<Nop>", { silent = true })
map("v", "x", "'d'", { expr = true, silent = true })
map("n", "<leader>1", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "<leader>2", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>k", vim.diagnostic.open_float, { desc = "Float diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
map("n", "<S-h>", "<C-o>", { noremap = true, silent = true })
map("n", "<S-l>", "<C-i>", { noremap = true, silent = true })
map("n", "<leader>w", "viw", { noremap = true, silent = true })
-- map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
-- map("n", "<leader>c", "<cmd>bdelete<cr>", { desc = "Close buffer" })
-- map("t", "<esc><esc>", "<F7>", { desc = "Toggle toggleterm" })

-- Function to set tmux pane title
Rename_tmux_pane = function()
	local current_directory = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":t")
	vim.api.nvim_command("silent !tmux rename-window '" .. current_directory .. "'")
end

-- Autocommand to update tmux pane title on VimEnter and BufEnter
vim.api.nvim_command([[autocmd DirChanged * lua Rename_tmux_pane()]])

vim.cmd([[set clipboard+=unnamedplus]])

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

require("lazy").setup({
	{ "tpope/vim-sensible" },
	{ import = "plugins" },
	{ import = "ftplugins" },
})

-- fennel setup
local function bootstrap(url, ref)
	local name = url:gsub(".*/", "")
	local path = vim.fn.stdpath([[data]]) .. "/lazy/" .. name

	if vim.fn.isdirectory(path) == 0 then
		print(name .. ": installing in data dir...")

		vim.fn.system({ "git", "clone", url, path })
		if ref then
			vim.fn.system({ "git", "-C", path, "checkout", ref })
		end

		vim.cmd([[redraw]])
		print(name .. ": finished installing")
	end
	vim.opt.runtimepath:prepend(path)
end

bootstrap("https://github.com/udayvir-singh/tangerine.nvim")

require("tangerine").setup({
	-- target = vim.fn.stdpath([[data]]) .. "/tangerine",
	compiler = {
		-- disable popup showing compiled files
		verbose = false,

		-- compile every time you change fennel files or on entering vim
		hooks = { "onsave", "oninit" },
	},
	keymaps = {
		-- set them to <Nop> if you want to disable them
		eval_buffer = "<Nop>",
		peek_buffer = "<Nop>",
		goto_output = "<Nop>",
		float = {
			next = "<Nop>",
			prev = "<Nop>",
			kill = "<Nop>",
			close = "<Nop>",
			resizef = "<Nop>",
			resizeb = "<Nop>",
		},
	},
})
