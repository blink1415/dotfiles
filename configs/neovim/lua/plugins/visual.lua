return {
    '00sapo/visual.nvim',
    dependencies = { "nvim-treesitter", "nvim-treesitter-textobjects" },
	enabled = false,
    event = "BufEnter", -- this is for making sure our keymaps are applied after the others: we call the previous mapppings, but other plugins/configs usually not!
    opts = { treesitter_textobjects = true },
    config = function()
        require('visual').setup({
            serendipity = {
                highlight = "guibg=LightSteelBlue guifg=none"
            },
            commands = {
                move_up_then_normal = { amend = true },
                move_down_then_normal = { amend = true },
                move_right_then_normal = { amend = true },
                move_left_then_normal = { amend = true },
            },
        })
    end,
}
