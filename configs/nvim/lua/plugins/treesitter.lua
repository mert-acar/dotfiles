return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
		},
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		local textobjects = require("nvim-treesitter-textobjects")
		local select_textobject = require("nvim-treesitter-textobjects.select")
		local move_textobject = require("nvim-treesitter-textobjects.move")

		local parsers = {
			"bash",
			"c",
			"html",
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
		}

		treesitter.setup({})
		treesitter.install(parsers)

		textobjects.setup({
			select = {
				lookahead = true,
				selection_modes = {
					["@parameter.outer"] = "v",
					["@parameter.inner"] = "v",
					["@function.outer"] = "v",
					["@conditional.outer"] = "V",
					["@loop.outer"] = "v",
					["@class.outer"] = "v",
				},
				include_surrounding_whitespace = false,
			},
			move = {
				set_jumps = true,
			},
		})

		local available = {}
		for _, language in ipairs(treesitter.get_available()) do
			available[language] = true
		end

		local ignored_install = {
			javascript = true,
		}
		local installing = {}

		local function start(buf, language)
			if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
				return
			end

			local loaded = vim.treesitter.language.add(language)
			if not loaded then
				return
			end

			vim.treesitter.start(buf, language)
			if vim.treesitter.query.get(language, "indents") then
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
			callback = function(args)
				local language = vim.treesitter.language.get_lang(args.match)
				if not language or not available[language] then
					return
				end

				if vim.treesitter.language.add(language) then
					start(args.buf, language)
					return
				end

				if ignored_install[language] then
					return
				end

				if installing[language] then
					installing[language][args.buf] = true
					return
				end

				local buffers = { [args.buf] = true }
				installing[language] = buffers

				treesitter.install(language):await(function(err, success)
					installing[language] = nil
					if err or not success then
						return
					end

					vim.schedule(function()
						for buf in pairs(buffers) do
							start(buf, language)
						end
					end)
				end)
			end,
			desc = "Enable Tree-sitter and install missing parsers",
		})

		vim.keymap.set("n", "<leader>vv", function()
			vim.treesitter.select("parent")
		end, { desc = "Start Tree-sitter selection" })
		vim.keymap.set("x", "+", function()
			vim.treesitter.select("parent")
		end, { desc = "Increment Tree-sitter selection" })
		vim.keymap.set("x", "_", function()
			vim.treesitter.select("child")
		end, { desc = "Decrement Tree-sitter selection" })

		local selections = {
			af = { "@function.outer", "Around a function" },
			["if"] = { "@function.inner", "Inside a function" },
			ac = { "@class.outer", "Around a class" },
			ic = { "@class.inner", "Inside a class" },
			aq = { "@parameter.outer", "Around a parameter" },
			iq = { "@parameter.inner", "Inside a parameter" },
		}
		local function map_selection(lhs, query, desc)
			vim.keymap.set({ "x", "o" }, lhs, function()
				select_textobject.select_textobject(query, "textobjects")
			end, { desc = desc })
		end
		for lhs, mapping in pairs(selections) do
			map_selection(lhs, mapping[1], mapping[2])
		end

		local movements = {
			["[f"] = { move_textobject.goto_previous_start, "@function.outer", "Previous function" },
			["[c"] = { move_textobject.goto_previous_start, "@class.outer", "Previous class" },
			["]f"] = { move_textobject.goto_next_start, "@function.outer", "Next function" },
			["]c"] = { move_textobject.goto_next_start, "@class.outer", "Next class" },
		}
		local function map_movement(lhs, move, query, desc)
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				move(query, "textobjects")
			end, { desc = desc })
		end
		for lhs, mapping in pairs(movements) do
			map_movement(lhs, mapping[1], mapping[2], mapping[3])
		end
	end,
}
