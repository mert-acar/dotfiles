return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function()
		require("oil").setup({
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false,
				["<C-l>"] = false,
				["<C-c>"] = false,
			},
			view_options = {
				show_hidden = true,
			},
		})
	end,
}
