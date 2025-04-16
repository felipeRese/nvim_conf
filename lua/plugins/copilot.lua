return {
  "github/copilot.vim",
  init = function()
    -- disable autocompletion (manual triggering only)
    vim.g.copilot_no_tab_map = true
  end,
}
