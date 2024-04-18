-- :fennel:1713436040
local opt = {ensure_installed = {"c", "cpp", "go", "lua", "python", "rust", "typescript", "vim", "php", "sql", "java", "fennel", "terraform"}, highlight = {enable = true}, indent = {enable = true, disable = {"python"}}, incremental_selection = {enable = true, keymaps = {init_selection = "<c-space>", node_incremental = "<c-space>", scope_incremental = "<c-s>", node_decremental = "<c-backspace>"}}, textobjects = {select = {enable = true, lookahead = true}}}
local function _1_()
  return require("nvim-treesitter.install").update({with_sync = true})
end
return {"nvim-treesitter/nvim-treesitter", dependencies = {"nvim-treesitter/nvim-treesitter-textobjects", "nvim-treesitter/nvim-treesitter-context"}, lazy = true, event = "BufEnter", init = _1_, opt = opt}