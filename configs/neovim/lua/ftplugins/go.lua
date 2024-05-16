-- :fennel:1715894140
local function _1_()
  require("go").setup({test_runner = "gotestsum", run_in_floaterm = true})
  return require("lspconfig").gopls.setup({settings = {gopls = {gofumpt = true}, hints = {rangeVariableTypes = true, parameterNames = true, constantValues = true, assignVariableTypes = true, compositeLiteralFields = true, compositeLiteralTypes = true, functionTypeParameters = true}}})
end
return {"ray-x/go.nvim", dependencies = {"ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter"}, lazy = true, config = _1_, ft = {"go", "gomod"}, build = {"':lua require(\"go.install\").update_all_sync()'", ":TSInstall go"}}