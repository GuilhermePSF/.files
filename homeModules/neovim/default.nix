{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.neovimModule.enable = lib.mkEnableOption "Enable Neovim Module";

  config = lib.mkIf config.neovimModule.enable {

    home.packages = with pkgs; [
      vim # system fallback editor
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        # LSP servers
        lua-language-server
        nil # Nix LSP
        nodePackages.typescript-language-server
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      ];

      plugins = with pkgs.vimPlugins; [
        # --- Plugin manager bootstrap ---
        lazy-nvim

        # --- Treesitter (syntax) ---
        nvim-treesitter.withAllGrammars

        # --- LSP ---
        nvim-lspconfig

        # --- Completion ---
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip
        cmp_luasnip

        # --- File tree ---
        nvim-tree-lua
        nvim-web-devicons

        # --- Fuzzy finder ---
        telescope-nvim
        plenary-nvim

        # --- Git ---
        gitsigns-nvim

        # --- Status line ---
        lualine-nvim

        # --- Stylix (base16 colours) ---
        base16-nvim
      ];

      extraLuaConfig = ''
        -- Basic options
        vim.opt.number         = true
        vim.opt.relativenumber = true
        vim.opt.expandtab      = true
        vim.opt.shiftwidth     = 2
        vim.opt.tabstop        = 2
        vim.opt.smartindent    = true
        vim.opt.wrap           = false
        vim.opt.termguicolors  = true
        vim.opt.signcolumn     = "yes"
        vim.opt.updatetime     = 250
        vim.opt.timeoutlen     = 300
        vim.opt.undofile       = true

        -- Leader
        vim.g.mapleader      = " "
        vim.g.maplocalleader = " "

        -- Colour scheme (Stylix injects base16 colours via base16-nvim)
        require("base16-colorscheme").setup(vim.g.base16_theme or {})

        -- Lualine
        require("lualine").setup({ options = { theme = "base16" } })

        -- Telescope keymaps
        local tb = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", tb.find_files,  { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", tb.live_grep,   { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", tb.buffers,     { desc = "Buffers" })

        -- Nvim-tree
        require("nvim-tree").setup()
        vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File tree" })

        -- LSP keymaps (attached per buffer)
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     opts)
            vim.keymap.set("n", "K",          vim.lsp.buf.hover,          opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    opts)
            vim.keymap.set("n", "<leader>f",  vim.lsp.buf.format,         opts)
          end,
        })

        -- LSP servers
        local lsp = require("lspconfig")
        lsp.lua_ls.setup({})
        lsp.nil_ls.setup({})
        lsp.tsserver.setup({})

        -- Completion
        local cmp     = require("cmp")
        local luasnip = require("luasnip")
        cmp.setup({
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"]      = cmp.mapping.confirm({ select = true }),
            ["<Tab>"]     = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
        })

        -- Gitsigns
        require("gitsigns").setup()
      '';
    };

    # Stylix handles the colour scheme via base16-nvim above
    stylix.targets.neovim.enable = true;
  };
}
