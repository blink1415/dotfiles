return {
    "Nsidorenco/tree-sitter-fsharp",
    dependencies = { -- optional packages
        "ionide/Ionide-vim",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    enabled = true,
    lazy = false,
    build = ":TSInstallFromGrammar fsharp",
    config = function()
        require("ionide").setup({})
        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
        parser_config.fsharp = {
            install_info = {
                url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
                branch = "develop",
                files = { "src/scanner.cc", "src/parser.c" },
                generate_requires_npm = true,
                requires_generate_from_grammar = true
            },
            filetype = "fsharp",
        }
    end,
}
