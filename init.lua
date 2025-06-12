require("config.lazy")

-- Set leader key
vim.g.mapleader = " "

-- Set line numbers
vim.wo.relativenumber = true
vim.opt.number = true

vim.cmd("COQnow [--shut-up]")

vim.keymap.set({ "n", "x" }, "<C-S-C>", '"+y', { desc = "Copy system clipboard" })
vim.keymap.set({ "n", "x" }, "<C-S-V>", '"+p', { desc = "Paste system clipboard" })

-- Not change cursor shape in insert mode
vim.opt.guicursor = ""
vim.cmd([[
  let &t_SI = ''
  let &t_SR = ''
  let &t_EI = ''
]])

if vim.g.neovide then
  vim.opt.guifont = "JetBrainsMono Nerd Font:h9"
  vim.g.remember_window_size = true
  vim.g.remember_window_position = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_fullscreen = true

  local function toggle_transparency()
    if vim.g.neovide_transparency == 1.0 then
      vim.cmd "let g:neovide_transparency=0.5"
    else
      vim.cmd "let g:neovide_transparency=1.0"
    end
  end

  local function toggle_fullscreen()
    if vim.g.neovide_fullscreen == false then
      vim.cmd "let g:neovide_fullscreen=v:true"
    else
      vim.cmd "let g:neovide_fullscreen=v:false"
    end
  end

  vim.keymap.set("n", "<F11>", toggle_fullscreen, { silent = true })
  vim.keymap.set("n", "<F10>", toggle_transparency, { silent = true })
end

vim.keymap.set('n', '<leader>cc', ':CopilotChatToggle<CR>', { noremap = true, silent = true })

local opt = vim.opt

-- Split to the right by default
vim.o.splitright = true

-- Indentation settings
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- Search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes case-sensitive

-- Disable swapfile
opt.swapfile = false

-- Fill empty lines in buffer with spaces
opt.fillchars = { eob = " " }

-- System clipboard
vim.opt.clipboard:append("unnamedplus")

-- Require keymaps from external file
require("config.keymaps")
