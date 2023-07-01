return {
    "akinsho/toggleterm.nvim",
    lazy = true,
    keys = {
        { "<c-o>", "<cmd>ToggleTerm<cr>", desc = "Toggle term" },
    },
    config = function()
        require("toggleterm").setup({
            direction = "float",
            size = function()
                return vim.o.columns * 0.5
            end,
            autochdir = true,
            winbar = {
                enabled = true,
                name_formatter = function(term)
                    return term.name
                end
            },
            open_mapping = [[<c-o>]],
            terminal_mappings = true,
        })
    end
}
