return {
    "akinsho/toggleterm.nvim",
    lazy = true,
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle term" },
    },
    config = function()
        require("toggleterm").setup({
            direction = "float",
            size = function()
                return vim.o.columns * 0.5
            end,
            autochdir = true,
        })
        function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          vim.keymap.set('n', '<esc><esc>', "<cmd>ToggleTerm<cr>", opts)
          vim.keymap.set('t', '<esc><esc>', "<cmd>ToggleTerm<cr>", opts)
        end

        -- if you only want these mappings for toggle term use term://*toggleterm#* instead
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
}
