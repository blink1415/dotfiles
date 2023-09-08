return {
   "m4xshen/hardtime.nvim",
   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
   event = "BufEnter",
   keys = {
      { "<leader>vr", "<cmd>Hardtime report<cr>", desc = "Vim optimization report" },
   },
   opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "neo-tree", "guihua" },
      disable_mouse = false,
      restricted_keys = {
         ["h"] = {},
         ["j"] = {},
         ["k"] = {},
         ["l"] = {},
      }
   }
}
