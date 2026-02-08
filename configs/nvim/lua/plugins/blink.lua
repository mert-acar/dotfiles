return {
	{ "L3MON4D3/LuaSnip", keys = {} },
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "*",
		config = function()
			require("blink.cmp").setup({
				snippets = { preset = "luasnip" },
				signature = { enabled = true },
				appearance = {
					use_nvim_cmp_as_default = false,
					nerd_font_variant = "normal",
				},
				sources = {
					default = { "snippets", "lsp", "path", "buffer" },
					providers = {
						cmdline = {
							min_keyword_length = 2,
						},
					},
				},
				keymap = {
					preset = "none",
					["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
					["<Tab>"] = { "select_and_accept", "fallback" },
					["<CR>"] = { "select_and_accept", "fallback" },
					["<C-j>"] = { "select_next", "fallback_to_mappings" },
					["<C-k>"] = { "select_prev", "fallback_to_mappings" },
				},
				completion = {
					keyword = { range = "full" },
					accept = { auto_brackets = { enabled = false } },
					list = { selection = { preselect = false, auto_insert = true } },
					menu = {
						border = nil,
						scrolloff = 1,
						scrollbar = false,
						draw = {
							columns = {
								{ "kind_icon" },
								{ "label", "label_description", gap = 1 },
								{ "kind" },
								{ "source_name" },
							},
						},
					},
					documentation = {
						window = {
							border = nil,
							scrollbar = false,
							winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
						},
						auto_show = true,
						auto_show_delay_ms = 500,
					},
				},
			})

			require("luasnip.loaders.from_vscode").lazy_load()

			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			ls.add_snippets("python", {
				s("sex", {
					t("raise SystemExit"),
				}),
			})

			ls.add_snippets("python", {
				s("main", {
					t('if __name__ == "__main__":'),
					t({ "", "    " }),
					i(0),
				}),
			})

			ls.add_snippets("go", {
				s("err", {
					t("if err != nil {"),
					t({ "", "    return err" }),
					t({ "", "}" }),
				}),
			})
		end,
	},
}
