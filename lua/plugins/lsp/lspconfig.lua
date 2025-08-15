return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    { "ms-jpq/coq_nvim", branch = "coq" },
    { "ms-jpq/coq.artifacts", branch = "artifacts" },
    { "ms-jpq/coq.thirdparty", branch = "3p" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  config = function()
    -- 1) COQ settings must come before requiring coq
    vim.g.coq_settings = {
      keymap = { recommended = false }, -- don't override our maps
    }

    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    local coq = require("coq")

    -- 2) Completions: keep <C-n>/<C-p> for COQ when menu is open
    local km_opts = { silent = true, expr = true }
    vim.keymap.set("i", "<C-n>", function()
      return (vim.fn.pumvisible() == 1) and "<Plug>(coq_navigate_next)" or "<C-n>"
    end, km_opts)
    vim.keymap.set("i", "<C-p>", function()
      return (vim.fn.pumvisible() == 1) and "<Plug>(coq_navigate_prev)" or "<C-p>"
    end, km_opts)

    -- 3) mason + mason-lspconfig
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "gopls",
        "luau_lsp",
        "ts_ls",
        "jsonls",
        "svelte",
        "graphql",
        "emmet_ls",
        "clangd",
      },
    })

    -- 4) Common LSP keymaps
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

    -- 5) Per-server settings
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

      -- Fixed clangd block (no LazyVim-specific glue; proper root_dir and filetypes)
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = function(fname)
          return util.root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            "Makefile",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },
    }

    -- 6) Setup all servers with COQ capabilities
    for server, cfg in pairs(servers) do
      lspconfig[server].setup(coq.lsp_ensure_capabilities(cfg))
    end
  end,
}

