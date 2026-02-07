return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>c",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff" },
			yaml = { "yq" },
			json = { "jq" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters = {
			ruff = {
				command = "ruff",
				args = { "format", "--force-exclude", "--stdin-filename", "$FILENAME", "-" },
				stdin = true,
			},
		},
	},
}
