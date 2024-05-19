return {

	{
		'rcarriga/nvim-dap-ui',
		opts = {},
		config = function(_, opts)
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup(opts)
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
			keys = {
				{ "<F5>",      ":lua require('dap').continue()<CR>",          desc = "Debug Continue" },
				{ "<F10>",     ":lua require('dap').step_over()<CR>",         desc = "Debug Step Over" },
				{ "<F11>",     ":lua require('dap').step_into()<CR>",         desc = "Debug Step Info" },
				{ "<F12>",     ":lua require('dap').step_out()<CR>",          desc = "Debug Step Out" },
				{ "<Leader>b", ":lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle Breakpoint" },
			}
		},
	},
	{
		'leoluz/nvim-dap-go',
		opts = {}
	},
	{
		'theHamsta/nvim-dap-virtual-text',
		opts = {}
	},
	{
		'nvim-neotest/nvim-nio'
	}
}
