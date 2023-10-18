return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	enabled = true,
	priority = 1000,
	config = function()
		require("kanagawa").setup()
		vim.cmd([[colorscheme kanagawa-lotus]])
	end
}
