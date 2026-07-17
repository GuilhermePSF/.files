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
      vim
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        lua-language-server
        nil
        nodePackages.typescript-language-server
        vscode-langservers-extracted
      ];

      plugins = with pkgs.vimPlugins; [
        lazy-nvim
        nvim-treesitter.withAllGrammars
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip
        cmp_luasnip
        nvim-tree-lua
        nvim-web-devicons
        telescope-nvim
        plenary-nvim
        gitsigns-nvim
        lualine-nvim
        base16-nvim
      ];

      extraLuaConfig = ''
        vim.opt.number         = true
        vim.opt.relativenumber = true
        vim.opt.expandtab      = true
        vim.opt.shiftwidth     = 2
        vim.opt.tabstop        = 2
        vim.opt.smartindent    = true
        vim.opt.wrap           = true
        vim.opt.termguicolors  = true
        vim.opt.signcolumn     = "yes"
        vim.opt.updatetime     = 250
        vim.opt.timeoutlen     = 300
        vim.opt.undofile       = true
        vim.g.mapleader      = " "
        vim.g.maplocalleader = " "
        local ok, base16 = pcall(require, "base16-colorscheme")
        if ok then
          if type(vim.g.base16_theme) == "table" then
            base16.setup(vim.g.base16_theme)
          else
            vim.cmd("colorscheme default")
          end
        end
        require("lualine").setup({ options = { theme = "base16" } })
        local tb = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", tb.find_files,  { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", tb.live_grep,   { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", tb.buffers,     { desc = "Buffers" })
        require("nvim-tree").setup()
        vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File tree" })
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

        local servers = { "lua_ls", "nil_ls", "ts_ls" }

        for _, server_name in ipairs(servers) do
          vim.lsp.config(server_name, {})
          vim.lsp.enable(server_name)
        end
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
        require("gitsigns").setup()
      '';
    };
    stylix.targets.neovim.enable = true;
  };
}
