return {
	'lukas-reineke/indent-blankline.nvim',
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("ibl").setup {
			whitespace = {
				remove_blankline_trail = true,
			},
			scope = { enabled = false },
		}
	end
}
