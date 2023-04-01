return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'williamboman/mason.nvim',
      keys = {
        { "<leader>lI", "<cmd>Mason<cr>", desc = "Manage LSPs" },
      },
    },
    'williamboman/mason-lspconfig.nvim',
    'j-hui/fidget.nvim',
    'folke/neodev.nvim',
  },
  lazy = true,
  event = "BufEnter",
  config = function()
    local mason = require('mason')
    mason.setup()
    local mason_lspconfig = require 'mason-lspconfig'

    local servers = {
      gopls = {},
      pyright = {},
      rust_analyzer = {},
      tsserver = {},
    }

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    local on_attach = function(_, bufnr)
      map('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Rename' })
      map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code action' })
      map('n', '<leader>lD', vim.lsp.buf.type_definition, { desc = 'Type definition' })
      map('n', '<leader>ls', require('telescope.builtin').lsp_document_symbols, { desc = 'Search document symbols' })
      map('n', '<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols,
      { desc = 'Search workspace symbols' })
      map('n', '<leader>lI', "<cmd>Mason<cr>", { desc = 'Manage LSPs' })

      map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      map('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Go to references' })
      map('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })

      -- See `:help K` for why this keymap
      map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
      map('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

      -- Lesser used LSP functionality
      map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })

      map('n', 'lf', "<cmd>Format<cr>", { desc = 'Formats current buffer with LSP' })
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        }
      end,
    }

    require('neodev').setup()
    require('fidget').setup()

  end
}
