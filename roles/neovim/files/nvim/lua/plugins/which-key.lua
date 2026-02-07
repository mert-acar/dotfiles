-- which-key helps you remember key bindings by showing a popup
-- with the active keybindings of the command you started typing.
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		notify = false,
		defaults = {},
		spec = {
			{
				mode = { "n", "v" },
				{ "<leader>c", group = "format" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>v", group = "LSP" },
				{ "<leader>gh", group = "git hunks" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>w", group = "save file" },
				{ "<leader>x", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "gs", group = "surround" },
				{ "z", group = "fold" },
			},
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps (which-key)",
		},
	},
	config = function(_, opts)
		require("which-key").setup(opts)
	end,
}
