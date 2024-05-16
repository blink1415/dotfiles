-- :fennel:1715329361
local opt = {ensure_installed = {"c", "cpp", "go", "lua", "python", "rust", "javascript", "typescript", "vim", "php", "sql", "java", "fennel", "terraform", "haskell"}, highlight = {enable = true}}
local function _1_()
  require("nvim-treesitter.install").update({with_sync = true})
  return require("nvim-treesitter.configs").setup(opt)
end
return {"nvim-treesitter/nvim-treesitter", dependencies = {"nvim-treesitter/nvim-treesitter-textobjects"}, lazy = true, event = "BufEnter", config = _1_}