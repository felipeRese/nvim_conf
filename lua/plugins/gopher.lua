return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function (opts)
    local map = vim.keymap.set

    map("n", "<leader>gie", "<cmd> GoIfErr <cr>", {desc ="add if err statement"})
    map("n", "<leader>gsj", "<cmd> GoTagAdd json <cr>", {desc ="add json struct tags"})
    map("n", "<leader>gsy", "<cmd> GoTagAdd yaml <cr>", {desc ="add yaml struct tags"})
    map("n", "<leader>gmt", "<cmd> GoMod tidy <cr>", {desc ="run go mod tidy"})


    require("gopher").setup(opts)
  end,
  build = function ()
    vim.cmd [[silent! GoInstallDeps]]
  end
}
