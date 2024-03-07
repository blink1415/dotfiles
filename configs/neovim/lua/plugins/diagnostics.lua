return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
		},
		event = "VeryLazy",
		keys = {
			{ "<leader>ld", "<cmd>TroubleToggle<cr>", desc = "Toggle diagnostics view" },
		},
	},
	{
		'dgagn/diagflow.nvim',
		event = 'LspAttach',
		opts = {
			scope = 'line',
		}
	}
}
