return {
  {
    "diepm/vim-rest-console",
    ft = { "rest" },
    init = function()
      -- no progress meter, body only
      vim.g.vrc_curl_opts = { ["-s"] = "", ["-S"] = "", ["-i"] = "" }
    end,
    keys = {
      {
        "<leader>rr",
        function()
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-j>", true, false, true),
            "n",
            false
          )
        end,
        desc = "REST: Run request",
      },
      { "<leader>jq", ":RestPretty<CR>", mode = "n", desc = "REST: Pretty JSON" },
    },
    config = function()
      -- Pretty-print (handles nomodifiable)
      vim.api.nvim_create_user_command("RestPretty", function()
        vim.bo.modifiable = true
        vim.cmd([[%!jq .]])
        vim.bo.modifiable = false
      end, {})

      -- When the output buffer opens, if it *looks* like JSON:
      -- 1) set ft=json for syntax/treesitter
      -- 2) (optional) auto-pretty with jq
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "__VRC_OUTPUT*",
        callback = function()
          local first = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
          if first:match("^%s*[{%[]") then
            -- enable JSON highlighting
            vim.bo.filetype = "json"

            -- optional: auto-format
            pcall(function()
              vim.bo.modifiable = true
              vim.cmd([[%!jq .]])
              vim.bo.modifiable = false
            end)
          end
        end,
      })

      -- If you sometimes include headers (curl -i), detect via Content-Type
      -- and still set ft=json:
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "__VRC_OUTPUT*",
        callback = function()
          -- scan first ~50 lines for a JSON content-type header
          local lines = vim.api.nvim_buf_get_lines(0, 0, math.min(50, vim.api.nvim_buf_line_count(0)), false)
          for _, l in ipairs(lines) do
            if l:lower():match("^content%-type:%s*application/json") then
              vim.bo.filetype = "json"
              break
            end
          end
        end,
      })
    end,
  },
}
