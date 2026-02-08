return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-plenary",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					-- dap = { justMyCode = false },
					runner = "pytest",
				}),
				require("neotest-plenary"),
			},
			discovery = {
				enabled = true,
				concurrent = 0,
				filter_dir = function(name, rel_path, root)
					-- Only include files in the "tests" directory or its subdirectories
					return rel_path:match("^tests/") or name == "tests"
				end,
			},
			quickfix = {
				open = false,
			},
			status = {
				virtual_text = true,
			},
			output = {
				open_on_run = true,
			},
		})
	end,
	keys = {
		{
			"<leader>zz",
			function()
				require("neotest").run.run()
			end,
			desc = "Run nearest test",
		},
		{
			"<leader>Z",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run all tests in file",
		},
		{
			"<leader>zs",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle test summary",
		},
		{
			"<leader>zo",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Open test output",
		},
		{
			"<leader>zl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run last test",
		},
		{
			"<leader>zf",
			function()
				require("neotest").run.run(vim.fn.getcwd())
			end,
			desc = "Run all tests in cwd",
		},
	},
}
