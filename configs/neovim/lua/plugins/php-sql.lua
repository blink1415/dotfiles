return {
	"gbprod/php-enhanced-treesitter.nvim",
	lazy = false,
	event = "BufEnter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"derekstride/tree-sitter-sql",
        "tree-sitter/tree-sitter-php"
	},
	ft = { "php" },
	build = ":TSInstall sql", -- if you need to install/update all binaries,
}
