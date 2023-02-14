return {
    "akinsho/toggleterm.nvim",
    lazy = true,
    keys = {
        { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle term" },
        { "<leader>T", "<cmd>ToggleTerm 2<cr>", desc = "Toggle term 2" },
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
            open_mapping = [[<esc><esc>]],
            terminal_mappings = true,
        })
    end
}
