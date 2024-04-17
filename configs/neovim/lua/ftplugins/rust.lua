return {
	"Saecki/crates.nvim",
	tag = "v0.3.0",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufRead Cargo.toml" },
	config = function()
		require("crates").setup()
	end,
}
