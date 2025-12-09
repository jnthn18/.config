vim.g.mapleader = " "

vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "which_key_ignore" }) -- clear search highlight
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open [Q]uickfix " })
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "File [E]xplorer" })
vim.keymap.set({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "which_key_ignore" }) -- edit nvim
vim.keymap.set({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "which_key_ignore" }) -- source nvim
vim.keymap.set({ "n", "v", "x" }, "<leader>O", "<Cmd>restart<CR>", { desc = "which_key_ignore" }) -- restart nvim

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
