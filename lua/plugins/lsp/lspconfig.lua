return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lua" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/vim-vsnip" },   -- ✅ snippet engine
    { "hrsh7th/cmp-vsnip" },   -- ✅ cmp source for vsnip
  },
  config = function()
    local cmp = require("cmp")
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

    -- helpers
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    -- ✅ nvim-cmp setup (SuperTab behaviour)
    cmp.setup({
      completion = { 
        autocomplete = false,
        completeopt = "menu,menuone,noinsert" 
      },
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn  == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true, -- ✅ auto-select first item if none chosen
        }),
      }),

      formatting = {
        fields = { "kind", "abbr", "menu" },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      performance = {
        max_view_entries = 20,
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          function(entry1, entry2)
            if entry1.completion_item.label == entry2.completion_item.label then
              return false
            end
          end,
          cmp.config.compare.exact,
          cmp.config.compare.length,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.order,
        },
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "vsnip" }, -- ✅ added vsnip source
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lua" },
      }),
    })

    cmp.event:on("confirm_done", function(evt)
      local entry = evt.entry
      local item = entry:get_completion_item()
      local kinds = { Function = 3, Method = 2 }
      if kinds[item.kind] then
        local keys = vim.api.nvim_replace_termcodes("()<Left>", true, false, true)
        vim.api.nvim_feedkeys(keys, "i", true)
      end
    end)

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local function is_nixos()
      local ok, f = pcall(io.open, "/etc/os-release", "r")
      if not ok or not f then return false end
      local data = f:read("*a") or ""
      f:close()
      return data:match("ID=nixos") ~= nil
    end
    local on_nixos = is_nixos()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>I", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>i", vim.diagnostic.open_float, opts)
        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        opts.desc = "Show documentation"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)
        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- configs por servidor
    local servers = {
      gopls = {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
          },
        },
      },

      luau_lsp = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      },

      svelte = {
        on_attach = function(client, _)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      },

      graphql = {
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      },

      emmet_ls = {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      },

      jsonls = {},

      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",
          "--fallback-style=llvm",
          "--limit-results=20",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = function(fname)
          return util.root_pattern(
            "compile_commands.json",
            ".clangd",
            ".git",
            "Makefile"
          )(fname) or util.path.dirname(fname)
        end,
        capabilities = capabilities,
        init_options = {
          usePlaceholders = true,
          clangdFileStatus = true,
        },
      },
    }

    require("mason").setup()
    local mlsp = require("mason-lspconfig")

    local base_ensure = {
      "gopls",
      "luau_lsp",
      "jsonls",
      "svelte",
      "graphql",
      "emmet_ls",
      "clangd",
    }

    if on_nixos then
      base_ensure = vim.tbl_filter(function(server)
        return server ~= "clangd"
      end, base_ensure)
    end

    mlsp.setup({ ensure_installed = base_ensure })

    for _, server in ipairs(vim.list_extend(vim.deepcopy(base_ensure), { "clangd" })) do
      local cfg = servers[server] or {}
      cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
      lspconfig[server].setup(cfg)
    end
  end,
}
