
return {
  "olimorris/codecompanion.nvim",
  config = function()
    require('codecompanion').setup({
      markdown = {
        code_blocks = {
          enable = true,
          languages = { "python", "lua", "javascript", "html", "css" }
        }
      }
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
      

