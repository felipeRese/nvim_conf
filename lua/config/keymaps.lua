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

-- Debugging keymaps
keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add breakpoint at line" })
keymap.set("n", "<leader>dus", function()
  require("dapui").toggle()
end, { desc = "Open debugging ui" })

keymap.set("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug go test" })

keymap.set("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { desc = "Debug last go test" })

keymap.set("n", "<leader>dso", "<cmd>DapStepOver<CR>", { desc = "Debugger Step Over" })
keymap.set("n", "<leader>dsi", "<cmd>DapStepInto<CR>", { desc = "Debugger Step Into" })
keymap.set("n", "<leader>dsu", "<cmd>DapStepOut<CR>", { desc = "Debugger Step Out" })
keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Debugger Continue" })
keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "Debugger Terminate" })

keymap.set("n", "nq", "<cmd>cn<CR>", { desc = "Next quickfix entry" })
keymap.set("n", "pq", "<cmd>cp<CR>", { desc = "Previous quickfix entry" })
