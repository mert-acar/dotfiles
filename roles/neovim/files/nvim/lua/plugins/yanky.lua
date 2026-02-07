return {
	"gbprod/yanky.nvim",
	dependencies = { "folke/snacks.nvim" },
	keys = {
		{
			"<leader>fp",
			function()
				Snacks.picker.yanky()
			end,
			mode = { "n", "x" },
			desc = "Open Yank History",
		},
		{
			"<leader>fP",
			vim.cmd.YankyClearHistory,
			mode = { "n", "x" },
			desc = "Clear Yank History",
		},
	},
}
