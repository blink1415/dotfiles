return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		event = "BufEnter",
		dependencies = {
			'neovim/nvim-lspconfig',
			{
				'williamboman/mason.nvim',
				build = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			'williamboman/mason-lspconfig.nvim',
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'L3MON4D3/LuaSnip',
			'nvim-telescope/telescope.nvim',
			'onsails/lspkind.nvim',
		},
		config = function()
			local lsp = require('lsp-zero').preset({})

			lsp.on_attach(function(_, bufnr)
				lsp.default_keymaps({
					buffer = bufnr
				})

				local desc = function(buf, desc)
					return {
						buffer = buf,
						desc = desc,
					}
				end


				vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>',
					desc(true, "Get references"))
				vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>',
					desc(true, "Go to definition"))
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<cr>',
					desc(true, "Go to implementation"))

				vim.keymap.set('n', '<leader>lD', '<cmd>lua vim.diagnostic.open_float()<cr>',
					desc(true, "Open floating diagnostic"))
				vim.keymap.set('n', '<leader>lf', '<cmd>LspZeroFormat<cr>', desc(true, "Format buffer"))
				vim.keymap.set('n', '<leader>q', '<cmd>Telescope diagnostics<cr>',
					desc(true, "Search diagnostics"))
				vim.keymap.set('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>',
					desc(true, "Code action"))
				vim.keymap.set('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>',
					desc(true, "Rename"))

				vim.keymap.set('n', '<leader>lk', '<cmd>lua vim.diagnostic.goto_prev()<cr>',
					desc(true, "Previous diagnostic"))
				vim.keymap.set('n', '<leader>lj', '<cmd>lua vim.diagnostic.goto_next()<cr>',
					desc(true, "Next diagnostic"))
			end)

			require('mason').setup({})
			require('mason-lspconfig').setup({
				-- Replace the language servers listed here
				-- with the ones you want to install
				ensure_installed = {},
				handlers = {
					lsp.default_setup,
				}
			})

			-- (Optional) Configure lua language server for neovim
			require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

			-- You need to setup `cmp` after lsp-zero
			local cmp = require('cmp')
			local cmp_action = require('lsp-zero').cmp_action()
			local lspkind = require('lspkind')

			cmp.setup({
				mapping = {
					-- `Enter` key to confirm completion
					['<CR>'] = cmp.mapping.confirm({ select = true }),

					-- Ctrl+Space to trigger completion menu
					['<C-Space>'] = cmp.mapping.complete(),

					['<C-j>'] = cmp.mapping.select_next_item(),
					['<C-k>'] = cmp.mapping.select_prev_item(),

					-- Navigate between snippet placeholder
					['<C-f>'] = cmp_action.luasnip_jump_forward(),
					['<C-b>'] = cmp_action.luasnip_jump_backward(),
				},
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						col_offset = -3,
						side_padding = 0,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry,
							vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
			})

			lsp.setup()
		end
	},
	{ "rafamadriz/friendly-snippets" }
}
