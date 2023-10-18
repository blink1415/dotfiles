return {
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
}
