-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--


return {
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		priority = 1000,
		config = function()
			require('catppuccin').setup({
				flavour = 'mocha'
			})
			require('catppuccin').load()
		end
	},
	{
		'jedrzejboczar/possession.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			autosave = {
				current = true
			}
		}
	},
	{
		'stevearc/oil.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			view_options = {
				show_hidden = true,
			}
		},
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" }
		}
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {}
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		}
	},
	{
		'connordeckers/tmux-navigator.nvim',
		opts = {
			enable = true
		}
	},
	{
		"ohakutsu/socks-copypath.nvim",
		config = function()
			require("socks-copypath").setup()
		end,
	},
	{
		'akinsho/toggleterm.nvim',
		enabled = false,
		version = "*",
		config = function()
			require("toggleterm").setup {
				open_mapping = [[<c-\>]],
				start_in_insert = true,
				insert_mappings = true,
				direction = 'horizontal',
				close_on_exit = true,
			}

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
				vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
				vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
				vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

			local Terminal     = require('toggleterm.terminal').Terminal
			local gitui        = Terminal:new({ cmd = "gitui", hidden = true })
			local devcontainer = Terminal:new({ cmd = "dcu", hidden = true })

			function _GITUI_TOGGLE()
				gitui:toggle()
			end

			function _DCU_TOGGLE()
				devcontainer:toggle()
			end

			vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _GITUI_TOGGLE()<CR>",
				{ desc = "Open GitUI", noremap = true, silent = true })
		end
	},
	{
		'stevearc/dressing.nvim',
		opts = {},
	}

}
