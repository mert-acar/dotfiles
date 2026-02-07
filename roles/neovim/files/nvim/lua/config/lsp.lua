vim.lsp.enable({
	"lua_ls",
	"pyright",
	"ruff",
})

vim.diagnostic.config({
	virtual_lines = false,
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local bufnr = args.buf

		-- Disable the built-in omnifunc to avoid conflicts with completion plugins
		vim.bo[bufnr].omnifunc = nil

		-- Disable LSP-based completion to avoid conflicts with completion plugins
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		vim.lsp.completion.enable(false, client.id, bufnr)

		-- Define buffer-local keymaps
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
		end

		local diagnostic_goto = function(next, severity)
			local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
			severity = severity and vim.diagnostic.severity[severity] or nil
			return function()
				go({ severity = severity })
			end
		end

		-- LSP keymaps
		-- Remove default LSP keymaps to avoid conflicts with custom keymaps

		-- vim.keymap.del("n", "grn", { buffer = bufnr })
		-- vim.keymap.del("n", "gra", { buffer = bufnr })
		-- vim.keymap.del("n", "grr", { buffer = bufnr })
		-- vim.keymap.del("n", "gri", { buffer = bufnr })
		-- vim.keymap.del("n", "grt", { buffer = bufnr })
		-- vim.keymap.del("n", "gO", { buffer = bufnr })
		-- vim.keymap.del("i", "<C-S>", { buffer = bufnr })
		-- vim.keymap.del("v", "an", { buffer = bufnr })
		-- vim.keymap.del("v", "in", { buffer = bufnr })

		-- Set custom LSP keymaps
		map("n", "<leader>vd", vim.diagnostic.open_float, "Show line diagnostics")
		map("n", "<leader>vr", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>va", vim.lsp.buf.code_action, "Code action")
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "Find references")
		map("n", "K", vim.lsp.buf.hover, "Show hover documentation")
		map("n", "<leader>vn", vim.diagnostic.goto_next, "Next diagnostic")
		map("n", "<leader>vp", vim.diagnostic.goto_prev, "Previous diagnostic")
		map("i", "<C-h>", vim.lsp.buf.signature_help, "Signiture help")
		map("n", "]d", diagnostic_goto(true), "Next Diagnostic")
		map("n", "[d", diagnostic_goto(false), "Prev Diagnostic")
		map("n", "]e", diagnostic_goto(true, "ERROR"), "Next Error")
		map("n", "[e", diagnostic_goto(false, "ERROR"), "Prev Error")
		map("n", "]w", diagnostic_goto(true, "WARN"), "Next Warning")
		map("n", "[w", diagnostic_goto(false, "WARN"), "Prev Warning")
	end,
})
