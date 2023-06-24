return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	enabled = true,
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			variablebuiltinStyle = { italic = true },
			specialReturn = true, -- special highlight for the return keyword
			specialException = true, -- special highlight for exception handling keywords
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			globalStatus = false, -- adjust window separators highlight for laststatus=3
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = {},
			overrides = function(colors)
				return {}
			end,
			theme = "wave",
			background = {
				dark = "wave",
				light = "lotus",
			},
		})
		vim.cmd([[colorscheme kanagawa]])
	end
}
