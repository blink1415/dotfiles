return {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    event = "BufEnter",
    config = function()
        require('gitsigns').setup {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            numhl = true,
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "right_align",
                delay = 0,
                ignore_whitespace = false,
            },
        }
    end
}
