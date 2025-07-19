[{1 :iamcco/markdown-preview.nvim
  :cmd [:MarkdownPreviewToggle :MarkdownPreview :MarkdownPreviewStop]
  :lazy true
  :ft [:markdown]
  :build (lambda [] ((. _G.vim.fn "mkdp#util#install")))}
 {1 :OXY2DEV/markview.nvim
  :lazy true
  :ft [:markdown]
  :opts {:preview {:icon_provider :devicons}}
  :dependencies [:saghen/blink.cmp :nvim-tree/nvim-web-devicons]}]
