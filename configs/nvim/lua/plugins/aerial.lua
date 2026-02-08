return {
	"stevearc/aerial.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>ts",
			function()
				require("aerial").toggle({ focus = true })
			end,
			desc = "Toggle Aerial",
		},
	},
	config = function()
		require("aerial").setup({
			autojump = true,
			layout = {
				default_direction = "prefer_left",
			},
			close_automatic_events = { "unsupported" },
		})
	end,
}
