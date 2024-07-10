-- :fennel:1716374202
local lsp_opts = {settings = {hints = {[{"rust-analyzer"}] = {inlayHints = {bindingModeHints = {enable = false}, chainingHints = {enable = true}, closingBraceHints = {enable = true, minLines = 25}, closureReturnTypeHints = {enable = "never"}, lifetimeElisionHints = {enable = "never", useParameterNames = false}, maxLength = 25, parameterHints = {enable = true}, reborrowHints = {enable = "never"}, renderColons = true, typeHints = {enable = true, hideClosureInitialization = false, hideNamedConstructor = false}}}}}}
local function _1_()
  return require("lspconfig").rust_analyzer.setup(lsp_opts)
end
return {"Saecki/crates.nvim", tag = "v0.3.0", dependencies = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}, event = "BufRead Cargo.toml", config = _1_}