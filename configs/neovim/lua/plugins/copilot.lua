return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<TAB>",
					next = "<C-j>",
					prev = "<C-k>",
				}
			}
		})
	end,
}
