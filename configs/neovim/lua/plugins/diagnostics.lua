return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		branch = "dev",
		opts = {
		},
		event = "VeryLazy",
		keys = {
			{ "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle diagnostics view" },
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
