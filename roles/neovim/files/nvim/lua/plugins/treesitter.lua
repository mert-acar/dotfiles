return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			sync_install = false,
			ignore_install = { "javascript" },
			modules = {},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			auto_install = true,
			ensure_installed = {
				"bash",
				"c",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"query",
				"regex",
				"vim",
				"vimdoc",
				"yaml",
				"rust",
				"go",
				"gomod",
				"gowork",
				"gosum",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>vv",
					node_incremental = "+",
					scope_incremental = false,
					node_decremental = "_",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = { query = "@function.outer", desc = "around a function" },
						["if"] = { query = "@function.inner", desc = "inner part of a function" },
						["ac"] = { query = "@class.outer", desc = "around a class" },
						["ic"] = { query = "@class.inner", desc = "inner part of a class" },
						["aq"] = { query = "@parameter.outer", desc = "around a parameter" },
						["iq"] = { query = "@parameter.inner", desc = "inner part of a parameter" },
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@parameter.inner"] = "v", -- charwise
						["@function.outer"] = "v", -- charwise
						["@conditional.outer"] = "V", -- linewise
						["@loop.outer"] = "v", -- linewise
						["@class.outer"] = "v", -- charwise
					},
					include_surrounding_whitespace = false,
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_previous_start = {
						["[f"] = { query = "@function.outer", desc = "Previous function" },
						["[c"] = { query = "@class.outer", desc = "Previous class" },
					},
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "Next function" },
						["]c"] = { query = "@class.outer", desc = "Next class" },
					},
				},
			},
		})
	end,
}
