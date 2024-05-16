-- :fennel:1714687446
local map = _G.vim.keymap.set
local function _1_()
  local actions = require("telescope.actions")
  require("telescope").setup({defaults = {mappings = {i = {["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous, ["<esc>"] = actions.close}}}})
  require("project_nvim").setup({detection_methods = {"pattern"}, patterns = {".git"}, ignore_lsp = {}, exclude_dirs = {}, silent_chdir = true, scope_chdir = "global", datapath = _G.vim.fn.stdpath("data"), show_hidden = false})
  map("n", "<leader><space>", require("telescope.builtin").buffers)
  local fuzzy_opts = require("telescope.themes").get_dropdown({winblend = 10, previewer = false})
  local buffer_fuzzy_find
  local function _2_()
    return require("telescope.builtin").current_buffer_fuzzy_find(fuzzy_opts)
  end
  buffer_fuzzy_find = _2_
  map("n", "<leader>/", buffer_fuzzy_find)
  map("n", "<leader>f", require("telescope.builtin").find_files)
  map("n", "<leader>sh", require("telescope.builtin").help_tags)
  map("n", "<leader>sw", require("telescope.builtin").grep_string)
  map("n", "<leader>g", require("telescope.builtin").live_grep)
  map("n", "<leader>p", "<cmd>Telescope projects<cr>")
  if (#_G.vim.fn.argv() == 0) then
    local function _3_()
      return _G.vim.cmd("Telescope projects")
    end
    return _G.vim.defer_fn(_3_, 0)
  else
    return nil
  end
end
return {"nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = {"nvim-lua/plenary.nvim", {dir = "/Users/nikolai/personal/project.nvim"}}, priority = 10000, init = _1_, lazy = false}