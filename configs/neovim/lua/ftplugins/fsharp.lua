-- :fennel:1713429390
local fsharp_config = {install_info = {url = "https://github.com/Nsidorenco/tree-sitter-fsharp", branch = "develop", files = {"src/scanner.cc", "src/parser.c"}, generate_requires_npm = true, requires_generate_from_grammar = true}, filetype = "fsharp"}
local function _1_()
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs
  parser_config["fsharp"] = fsharp_config
  return nil
end
return {"Nsidorenco/tree-sitter-fsharp", dependencies = {"ionide/Ionide-vim", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter"}, lazy = true, event = "VeryLazy", ft = {"fs", "fsproj"}, init = _1_, enabled = false}