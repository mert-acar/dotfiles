return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	ft = { "markdown" },
	keys = {
		{ "<leader>m", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle markdown rendering" },
	},
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		-- math is typeset as images by snacks.image
		latex = { enabled = false },
	},
}
