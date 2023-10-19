return {
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",

			"leoluz/nvim-dap-go",

			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
		},
		lazy = true,
		keys = {
			{ "<leader>lt", "<cmd>GoTestSum<cr>",    desc = "Run tests" },
		},
		config = function()
			require("go").setup({
				-- test_runner = "gotestsum",
				run_in_floaterm = true,
			})

			local desc = function(buf, desc)
				return {
					buffer = buf,
					desc = desc,
				}
			end
			vim.keymap.set('n', '<leader>db', '<cmd>GoBreakToggle<cr>', desc(true, "Toggle breakpoints"))
			vim.keymap.set('n', '<leader>ds', '<cmd>GoDebugStart<cr>', desc(true, "Start debug"))
			vim.keymap.set('n', '<leader>dq', '<cmd>GoDbgStop<cr>', desc(true, "Stop debug"))

			-- DAP
			require('dap-go').setup {
				-- Additional dap configurations can be added.
				-- dap_configurations accepts a list of tables where each entry
				-- represents a dap configuration. For more details do:
				-- :help dap-configuration
				dap_configurations = {
					{
						-- Must be "go" or it will be ignored by the plugin
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
				-- delve configurations
				delve = {
					-- time to wait for delve to initialize the debug session.
					-- default to 20 seconds
					initialize_timeout_sec = 20,
					-- a string that defines the port to start delve debugger.
					-- default to string "${port}" which instructs nvim-dap
					-- to start the process in a random available port
					port = "${port}"
				},
			}
		end,
		ft = { "go", 'gomod' },
		build = {
			':lua require("go.install").update_all_sync()',
			':TSInstall go',
		} -- if you need to install/update all binaries
	},
}
