-- :fennel:1713977843
local function _1_()
  require("go").setup({test_runner = "gotestsum", run_in_floaterm = true})
  return require("lspconfig").gopls.setup({settings = {gopls = {gofumpt = true}}})
end
return {"ray-x/go.nvim", dependencies = {"ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter"}, lazy = true, keys = {{"<leader>lt", "<cmd>GoTestSum<cr>", desc = "Run tests"}}, config = _1_, ft = {"go", "gomod"}, build = {"':lua require(\"go.install\").update_all_sync()'", ":TSInstall go"}}