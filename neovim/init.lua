local original_notify = vim.notify
vim.notify = function(msg, ...)
	if type(msg) == "string" and msg:match("vim%.tbl_islist is deprecated") then
		return
	end
	original_notify(msg, ...)
end

-- This file is only used to bootstrap fennel
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

bootstrap("https://github.com/udayvir-singh/hibiscus.nvim", "v1.7")
bootstrap("https://github.com/whmountains/tangerine.nvim")

require("tangerine").setup({
	target = vim.fn.stdpath([[config]]) .. "/lua",
	compiler = {
		-- disable popup showing compiled files
		verbose = false,

		-- compile every time you change fennel files or on entering vim
		hooks = { "onsave", "oninit" },
	},
	keymaps = {
		-- set them to <Nop> if you want to disable them
		eval_buffer = "<Nop>",
		peek_buffer = "<leader>lP",
		goto_output = "<Nop>",
		float = {
			next = "<Nop>",
			prev = "<Nop>",
			kill = "<Nop>",
			close = "<esc>",
			resizef = "<Nop>",
			resizeb = "<Nop>",
		},
	},
})
