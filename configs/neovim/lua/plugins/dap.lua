return {
    "leoluz/nvim-dap-go",
    dependencies = { -- optional packages
        "mfussenegger/nvim-dap",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
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
    event = { "CmdlineEnter" },
    ft = { "go" },
    build = ':TSInstall go' -- if you need to install/update all binaries
}
