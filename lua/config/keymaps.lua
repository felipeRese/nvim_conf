-- Keymaps
local keymap = vim.keymap

-- Move between windows
keymap.set("n", "<C-h>", "<C-w>h") -- Move to the left window
keymap.set("n", "<C-j>", "<C-w>j") -- Move to the window below
keymap.set("n", "<C-k>", "<C-w>k") -- Move to the window above
keymap.set("n", "<C-l>", "<C-w>l") -- Move to the right window

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>nq", "<cmd>cn<CR>", { desc = "Next quickfix entry" })
keymap.set("n", "<leader>pq", "<cmd>cp<CR>", { desc = "Previous quickfix entry" })
