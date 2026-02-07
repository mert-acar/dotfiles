-- Neovim Keymaps
local map = vim.keymap.set

-- -- Resize window using <ctrl> arrow keys
-- map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
-- map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
-- map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
-- map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- save file
map({ "i", "x", "n", "s" }, "<leader>w", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q!<cr>", { desc = "Close File" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- diagnostic
map("n", "<leader>ef", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Move Lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down" })

map("n", "J", "mzJ`z", { desc = "Join line below" })

-- Better navigation (less dizzying)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-b>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("i", "<C-c>", "<Esc>") -- animal behavior

map("n", "<leader>rr", "oraise SystemExit<Esc>", { desc = "Insert SystemExit" })
map("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = "Insert err != nil" })

map("x", "p", '"_dP', { noremap = true, desc = "Paste over selection without updating register" })
