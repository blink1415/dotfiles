return {
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',

  {
    'lukas-reineke/indent-blankline.nvim',
    lazy = false,
    config = function()
      require("ibl").setup {
        whitespace = {
          remove_blankline_trail = true,
        },
        scope = { enabled = false },
      }
    end
  },
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      require('Comment').setup()
    end
  },


  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1,
    lazy = false,
    config = function()
      pcall(require('telescope').load_extension, 'fzf')
    end
  }

}
