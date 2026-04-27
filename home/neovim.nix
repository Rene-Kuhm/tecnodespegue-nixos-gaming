{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      lua-language-server
      nil
      typescript-language-server
      gopls
      rust-analyzer
      pyright
      bash-language-server
      stylua
      prettier
      black
      shfmt
      nixfmt
      ripgrep
      fd
      gcc
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-web-devicons
      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-lua tree-sitter-nix tree-sitter-javascript
        tree-sitter-typescript tree-sitter-tsx tree-sitter-python
        tree-sitter-go tree-sitter-rust tree-sitter-bash
        tree-sitter-json tree-sitter-yaml tree-sitter-toml
        tree-sitter-markdown tree-sitter-html tree-sitter-css
      ]))
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets
      neo-tree-nvim
      nui-nvim
      nvim-window-picker
      telescope-nvim
      telescope-fzf-native-nvim
      gitsigns-nvim
      lualine-nvim
      bufferline-nvim
      indent-blankline-nvim
      noice-nvim
      nvim-notify
      toggleterm-nvim
      nvim-autopairs
      comment-nvim
      which-key-nvim
      conform-nvim
      flash-nvim
      trouble-nvim
      todo-comments-nvim
      oil-nvim
    ];

    initLua = ''
      -- Opciones base
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true
      opt.smartindent = true
      opt.wrap = false
      opt.swapfile = false
      opt.backup = false
      opt.undofile = true
      opt.hlsearch = false
      opt.incsearch = true
      opt.termguicolors = true
      opt.scrolloff = 8
      opt.signcolumn = "yes"
      opt.updatetime = 50
      opt.splitright = true
      opt.splitbelow = true
      opt.cursorline = true
      opt.pumheight = 10
      opt.conceallevel = 2

      -- Tema
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          treesitter = true, nvimtree = false, neo_tree = true,
          telescope = { enabled = true }, lsp_trouble = true,
          which_key = true, gitsigns = true, indent_blankline = { enabled = true },
          noice = true, notify = true, bufferline = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")

      -- Treesitter
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      -- Notify + Noice
      require("notify").setup({ background_colour = "#1e1e2e" })
      require("noice").setup({
        lsp = { override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        }},
        presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
      })

      -- Lualine
      require("lualine").setup({
        options = { theme = "catppuccin", globalstatus = true },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })

      -- Bufferline
      require("bufferline").setup({ options = { diagnostics = "nvim_lsp" } })

      -- Indent blankline
      require("ibl").setup({ indent = { char = "│" }, scope = { enabled = true } })

      -- Neo-tree
      require("neo-tree").setup({
        window = { width = 30 },
        filesystem = {
          filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
          follow_current_file = { enabled = true },
        },
      })

      -- Oil
      require("oil").setup({
        default_file_explorer = false,
        view_options = { show_hidden = true },
      })

      -- Telescope
      local telescope = require("telescope")
      telescope.setup({
        defaults = { file_ignore_patterns = { "node_modules", ".git/" } },
        extensions = { fzf = {} },
      })
      telescope.load_extension("fzf")

      -- Gitsigns
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" }, change = { text = "▎" },
          delete = { text = "" }, topdelete = { text = "" }, changedelete = { text = "▎" },
        },
      })

      -- Autopairs
      require("nvim-autopairs").setup({ check_ts = true })

      -- Comment
      require("Comment").setup()

      -- Which-key
      require("which-key").setup()

      -- Todo comments
      require("todo-comments").setup()

      -- Trouble
      require("trouble").setup()

      -- Flash
      require("flash").setup()

      -- Toggleterm (opencode y terminal general)
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        direction = "float",
        float_opts = { border = "curved" },
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local opencode = Terminal:new({
        cmd = "opencode",
        direction = "float",
        float_opts = { border = "curved", width = math.floor(vim.o.columns * 0.9), height = math.floor(vim.o.lines * 0.9) },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
        end,
      })
      function _OPENCODE_TOGGLE() opencode:toggle() end

      -- LSP
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } } },
        nil_ls = {},
        ts_ls = {},
        gopls = {},
        rust_analyzer = {},
        pyright = {},
        bashls = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Completado
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "luasnip" },
        }, {
          { name = "buffer" }, { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Conform (formateo)
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettier" }, typescript = { "prettier" },
          javascriptreact = { "prettier" }, typescriptreact = { "prettier" },
          json = { "prettier" }, yaml = { "prettier" }, markdown = { "prettier" },
          python = { "black" }, go = { "gofmt" }, sh = { "shfmt" },
          nix = { "nixfmt" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })

      -- Keymaps
      local map = vim.keymap.set

      -- Navegación
      map("n", "<C-h>", "<C-w>h")
      map("n", "<C-j>", "<C-w>j")
      map("n", "<C-k>", "<C-w>k")
      map("n", "<C-l>", "<C-w>l")
      map("n", "<C-Up>", ":resize +2<CR>")
      map("n", "<C-Down>", ":resize -2<CR>")
      map("n", "<C-Left>", ":vertical resize -2<CR>")
      map("n", "<C-Right>", ":vertical resize +2<CR>")

      -- Buffers
      map("n", "<S-l>", ":bnext<CR>")
      map("n", "<S-h>", ":bprevious<CR>")
      map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

      -- Explorer
      map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "File explorer" })
      map("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus explorer" })
      map("n", "-", ":Oil<CR>", { desc = "Oil file manager" })

      -- Telescope
      local tb = require("telescope.builtin")
      map("n", "<leader>ff", tb.find_files, { desc = "Find files" })
      map("n", "<leader>fg", tb.live_grep, { desc = "Live grep" })
      map("n", "<leader>fb", tb.buffers, { desc = "Buffers" })
      map("n", "<leader>fh", tb.help_tags, { desc = "Help" })
      map("n", "<leader>fr", tb.oldfiles, { desc = "Recent files" })
      map("n", "<leader>fc", tb.commands, { desc = "Commands" })
      map("n", "<leader>/", tb.current_buffer_fuzzy_find, { desc = "Search in buffer" })

      -- Git
      local gs = require("gitsigns")
      map("n", "<leader>gb", gs.blame_line, { desc = "Git blame" })
      map("n", "<leader>gd", gs.diff_this, { desc = "Git diff" })
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
      map("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })

      -- Trouble
      map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
      map("n", "<leader>xb", ":Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })

      -- Formateo
      map("n", "<leader>cf", function() require("conform").format({ async = true }) end, { desc = "Format" })

      -- Flash
      map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })

      -- opencode
      map("n", "<leader>oc", "<cmd>lua _OPENCODE_TOGGLE()<CR>", { desc = "opencode" })
      map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
      map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Terminal float" })

      -- Misc
      map("n", "<leader>w", ":w<CR>", { desc = "Save" })
      map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
      map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search" })
      map("v", "<", "<gv")
      map("v", ">", ">gv")
      map("v", "J", ":m '>+1<CR>gv=gv")
      map("v", "K", ":m '<-2<CR>gv=gv")
    '';
  };
}
