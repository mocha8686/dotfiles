{ lib, ... }:
{
  plugins = {
    todo-comments.enable = true;
    gitsigns.enable = true;
    git-conflict.enable = true;
    vim-matchup.enable = true;

    lspconfig.enable = true;

    spectre = {
      enable = true;
    };

    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "'<leader>to'";
        direction = "vertical";
        hide_numbers = true;
        insert_mappings = false;
        persist_mode = false;
        persist_size = false;
        shade_terminals = false;
        size = lib.nixvim.mkRaw "vim.o.columns * 0.4";
        terminal_mappings = false;
      };
    };

    ccc = {
      enable = true;
      settings = {
        inputs = [
          "ccc.input.oklch"
          "ccc.input.hsl"
          "ccc.input.rgb"
          "ccc.input.cmyk"
        ];
        outputs = [
          "ccc.output.css_oklch"
          "ccc.output.css_hsl"
          "ccc.output.hex_short"
          "ccc.output.hex"
          "ccc.output.css_rgb"
        ];
        highlighter = {
          auto_enable = true;
          filetypes = [
            "html"
            "css"
            "scss"
            "sass"
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
            "markdown"
            "mdx"
          ];
        };
      };
    };

    mini = {
      enable = true;
      mockDevIcons = true;

      modules = {
        # Editing
        ai = { };
        align = { };
        keymap = { };
        move = { };
        operators = { };
        pairs = { };
        splitjoin = { };
        surround = { };
        completion = { };
        snippets = {
          snippets = [
            (lib.nixvim.mkRaw "require('mini.snippets').gen_loader.from_lang()")
          ];
        };

        # General
        bracketed = {
          diagnostic.options.float = true;
        };
        cmdline = { };
        diff = { };
        extra = { };
        files = {
          mappings = {
            go_in = "L";
            go_in_plus = "l";
            go_out = "h";
            go_out_plus = "H";
          };
        };
        git = { };
        jump = { };
        jump2d = {
          mappings.start_jumping = "z";
        };
        pick = { };

        # Appearance
        icons = {
          mockDevIcons = true;
        };
        indentscope = { };
        notify = { };
        tabline = { };

        # Extra
        clue = {
          window.delay = 250;
          triggers = lib.nixvim.mkRaw ''
            {
            	-- Leader triggers
            	{ mode = 'n', keys = '<Leader>' },
            	{ mode = 'x', keys = '<Leader>' },

            	-- Built-in completion
            	{ mode = 'i', keys = '<C-x>' },

            	-- `g` key
            	{ mode = 'n', keys = 'g' },
            	{ mode = 'x', keys = 'g' },

            	-- Marks
            	{ mode = 'n', keys = "'" },
            	{ mode = 'n', keys = '`' },
            	{ mode = 'x', keys = "'" },
            	{ mode = 'x', keys = '`' },

            	-- Registers
            	{ mode = 'n', keys = '"' },
            	{ mode = 'x', keys = '"' },
            	{ mode = 'i', keys = '<C-r>' },
            	{ mode = 'c', keys = '<C-r>' },

            	-- Window commands
            	{ mode = 'n', keys = '<C-w>' },
            }
          '';
          clues = lib.nixvim.mkRaw ''
            {
            	{ mode = 'n', keys = '<leader>c', desc = '+CCC' },
            	{ mode = 'n', keys = '<leader>s', desc = '+Spectre' },
            	{ mode = 'n', keys = '<leader>t', desc = '+Toggleterm' },
            	{ mode = 'n', keys = '<leader>l', desc = '+LSP' },

            	require('mini.clue').gen_clues.builtin_completion(),
            	require('mini.clue').gen_clues.g(),
            	require('mini.clue').gen_clues.marks(),
            	require('mini.clue').gen_clues.registers(),
            	require('mini.clue').gen_clues.windows(),
            }
          '';
        };
        statusline =
          let
            fn = lib.nixvim.mkRaw ''
              function()
              	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
              	local git           = MiniStatusline.section_git({ trunc_width = 40 })
              	local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
              	local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
              	local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
              	local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
              	local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
              	-- local location   = MiniStatusline.section_location({ trunc_width = 75 })
              	local location      = '%l %v'
              	local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

              	return MiniStatusline.combine_groups({
              		{ hl = mode_hl,                       strings = { string.upper(mode) } },
              		{ hl = 'MiniStatuslineDevinfo',       strings = { git, diff, diagnostics, lsp } },
              		'%<', -- Mark general truncate point
              		{ hl = 'MiniStatuslineFilename',      strings = { filename } },
              		'%=', -- End left alignment
              		{ hl = 'MiniStatuslineFileinfo',      strings = { fileinfo } },
              		{ hl = mode_hl,                       strings = { search, location } },
              	})
              end
            '';
          in
          {
            content.active = fn;
            content.inactive = fn;
          };
      };
    };

    snacks = {
      enable = true;
      settings = {
        image.enable = true;
        quickfile.enable = true;
      };
    };

    none-ls = {
      enable = true;

      sources.formatting.alejandra.enable = true;
      sources.code_actions.statix.enable = true;

      sources.prettier = {
        enable = true;
        disableTsServerFormatter = true;
      };
    };
  };

  lsp = {
    inlayHints.enable = true;

    servers = {
      astro.enable = true;
      biome.enable = true;
      eslint.enable = true;
      jsonls.enable = true;
      nil_ls.enable = true;
      qmlls.enable = true;
      rust_analyzer.enable = true;
      statix.enable = true;
      stylelint.enable = true;
      ts_ls.enable = true;
    };

    keymaps = [
      {
        key = "K";
        lspBufAction = "hover";
        options.desc = "Display hover info";
      }
      {
        key = "<leader>lD";
        lspBufAction = "declaration";
        options.desc = "Go to declaration";
      }
      {
        key = "<leader>ld";
        lspBufAction = "definition";
        options.desc = "Go to definition";
      }
      {
        key = "<leader>li";
        lspBufAction = "implementation";
        options.desc = "Go to implementation";
      }
      {
        key = "<leader>lS";
        lspBufAction = "signature_help";
        options.desc = "Show signature info";
      }
      {
        key = "<leader>lR";
        lspBufAction = "rename";
        options.desc = "Rename symbol";
      }
      {
        key = "<leader>lA";
        lspBufAction = "code_action";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Show code actions";
      }
      {
        key = "<leader>lf";
        action = lib.nixvim.mkRaw "function() vim.lsp.buf.format { async = true } end";
        options.desc = "Format buffer";
      }
    ];
  };

  diagnostic.settings = {
    signs = {
      text = lib.nixvim.mkRaw ''
        {
        	[vim.diagnostic.severity.ERROR] = '',
        	[vim.diagnostic.severity.WARN] = '',
        	[vim.diagnostic.severity.INFO] = '󰋼',
        	[vim.diagnostic.severity.HINT] = '󰌵',
        },
      '';
      numhl = lib.nixvim.mkRaw ''
        {
        	[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        	[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        	[vim.diagnostic.severity.HINT] = 'DiagnosticSignInfo',
        	[vim.diagnostic.severity.INFO] = 'DiagnosticSignHint',
        }
      '';
    };
  };

  extraConfigLua = ''
    require('neopywal').setup { use_wallust = true }
    vim.cmd.colorscheme 'neopywal'

    require('focus').setup()

    local map_multistep = require('mini.keymap').map_multistep
    map_multistep('i', '<Tab>', { 'pmenu_next' })
    map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
    map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
    map_multistep('i', '<BS>', { 'minipairs_bs' })

    vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "IncSearch" })
  '';

  globals = {
    mapleader = " ";
    maplocalleader = "\\";
  };

  opts = {
    # Navigation
    backspace = "indent,eol,start";
    hlsearch = true;
    ignorecase = true;
    incsearch = true;
    smartcase = true;
    splitbelow = true;
    splitright = true;
    whichwrap = "b,s,<,>,[,]";

    # Editing
    autoindent = true;
    expandtab = false;
    shiftwidth = 4;
    tabstop = 4;
    undofile = true;
    virtualedit = "onemore,block";
    history = 25;

    # Styling
    encoding = "utf-8";
    laststatus = 3;
    list = true;
    listchars = {
      trail = "⋅";
      extends = "⟩";
      precedes = "⟨";
      tab = "»⋅";
      nbsp = "␣";
    };
    number = true;
    relativenumber = true;
    scrolloff = 12;
    showbreak = "↪ ";
    showcmd = true;
    showmode = false;
    sidescroll = 10;
    signcolumn = "yes";
    termguicolors = true;
    title = true;
    updatetime = 150;
    winborder = "rounded";
    wrap = false;
    fillchars = {
      stl = " ";
      stlnc = " ";
      wbr = " ";
    };
  };

  autoGroups = {
    "NumberOnFocus".clear = true;
    "DisableFocus".clear = true;
  };

  autoCmd =
    let
      noNumbers = "(vim.b['term_title'] or vim.bo.filetype == 'man' or vim.bo.filetype == 'help' or string.find(vim.bo.filetype, 'dap'))";
      wrapFiletypes = [
        "text"
        "markdown"
        "tex"
        "plaintex"
        "mdx"
        "typst"
      ];
      focusIgnoreFiletypes = "{ 'trouble' }";
      focusIgnoreBuftypes = "{ 'nofile', 'prompt', 'popup' }";
    in
    [
      {
        event = [
          "BufEnter"
          "FocusGained"
          "InsertLeave"
        ];
        group = "NumberOnFocus";
        pattern = "*";
        callback = lib.nixvim.mkRaw ''
          function()
          	if not ${noNumbers} then
          		vim.o.relativenumber = true
          	end
          end
        '';
      }
      {
        event = [
          "BufLeave"
          "FocusLost"
          "InsertEnter"
        ];
        group = "NumberOnFocus";
        pattern = "*";
        callback = lib.nixvim.mkRaw ''
          function()
          	if not ${noNumbers} then
          		vim.o.relativenumber = false
          	end
          end
        '';
      }
      {
        event = [ "FileType" ];
        pattern = wrapFiletypes;
        callback = lib.nixvim.mkRaw ''
          function()
          	vim.o.wrap = true
          	vim.o.linebreak = true
          end
        '';
      }
      {
        event = [ "TermOpen" ];
        pattern = "*";
        callback = lib.nixvim.mkRaw ''
          function()
          	vim.opt_local.number = false
          	vim.opt_local.relativenumber = false
          end
        '';
      }
      {
        event = [ "WinEnter" ];
        group = "DisableFocus";
        pattern = "*";
        callback = lib.nixvim.mkRaw ''
          function()
          	if vim.tbl_contains(${focusIgnoreBuftypes}, vim.bo.buftype) then
          		vim.w.focus_disable = true
          	else
          		vim.w.focus_disable = false
          	end
          end
        '';
      }
      {
        event = [ "FileType" ];
        group = "DisableFocus";
        pattern = "*";
        callback = lib.nixvim.mkRaw ''
          function()
          	if vim.tbl_contains(${focusIgnoreFiletypes}, vim.bo.filetype) then
          		vim.w.focus_disable = true
          	else
          		vim.w.focus_disable = false
          	end
          end
        '';
      }
      {
        event = [ "User" ];
        pattern = "MiniFilesActionRename";
        callback = lib.nixvim.mkRaw ''
          function(event)
          	Snacks.rename.on_rename_file(event.data.from, event.data.to)
          end
        '';
      }
    ];

  keymaps = [
    {
      key = "<C-h>";
      action = "<Cmd>wincmd h<CR>";
      mode = [
        "n"
        "t"
      ];
      options.desc = "Select window to the left";
    }
    {
      key = "<C-j>";
      action = "<Cmd>wincmd j<CR>";
      mode = [
        "n"
        "t"
      ];
      options.desc = "Select window below";
    }
    {
      key = "<C-k>";
      action = "<Cmd>wincmd k<CR>";
      mode = [
        "n"
        "t"
      ];
      options.desc = "Select window above";
    }
    {
      key = "<C-l>";
      action = "<Cmd>wincmd l<CR>";
      mode = [
        "n"
        "t"
      ];
      options.desc = "Select window to the right";
    }
    {
      key = "<leader>w";
      action = "<Cmd>bd<CR>";
      options.desc = "Close buffer";
    }
    {
      key = "<leader>q";
      action = "<Cmd>wincmd q<CR>";
      options.desc = "Close window";
    }
    {
      key = "<Tab>";
      action = "<Cmd>bn<CR>";
      options.desc = "Select next buffer";
    }
    {
      key = "<S-Tab>";
      action = "<Cmd>bp<CR>";
      options.desc = "Select previous buffer";
    }
    {
      key = "]q";
      action = "<Cmd>cn<CR>";
      options.desc = "Next quickfix";
    }
    {
      key = "[q";
      action = "<Cmd>cp<CR>";
      options.desc = "Previous quickfix";
    }
    {
      key = "<Up>";
      action = "gk";
      mode = [
        "n"
        "v"
      ];
    }
    {
      key = "<Down>";
      action = "gj";
      mode = [
        "n"
        "v"
      ];
    }
    {
      key = "<C-Left>";
      action = "g0";
      mode = [
        "n"
        "v"
      ];
    }
    {
      key = "<C-Right>";
      action = "g$";
      mode = [
        "n"
        "v"
      ];
    }
    {
      key = "<C-p>";
      action = "<Cmd>Pick files<CR>";
      options.desc = "Pick files";
    }
    {
      key = "<C-p>";
      action = "<Cmd>Pick files<CR>";
      options.desc = "Pick files";
    }
    {
      key = "<leader>p";
      action = "<Cmd>Pick grep_live<CR>";
      options.desc = "Live grep";
    }
    {
      key = "<leader>h";
      action = "<Cmd>Pick help<CR>";
      options.desc = "Pick help";
    }
    {
      key = "<leader>cp";
      action = "<Cmd>CccPick<CR>";
      options.desc = "Pick/convert a color";
    }
    {
      key = "<C-t>";
      action = lib.nixvim.mkRaw "function() MiniFiles.open() end";
      options.desc = "Open files";
    }
    {
      key = "s";
      action = "s";
      mode = [
        "n"
        "v"
      ];
    }
    {
      key = "<C-'>";
      action = "<C-\\><C-n>'";
      mode = [ "t" ];
      options.desc = "Exit to normal mode";
    }
    {
      key = "<leader>so";
      action = lib.nixvim.mkRaw "function() require('spectre').toggle() end";
      options.desc = "Toggle Spectre";
    }
    {
      key = "<leader>sw";
      action = lib.nixvim.mkRaw "function() require('spectre').open_visual({ select_word = true }) end";
      options.desc = "Search current word";
    }
    {
      key = "<leader>sw";
      action = lib.nixvim.mkRaw "function() require('spectre').open_visual() end";
      mode = "v";
      options.desc = "Search current word";
    }
    {
      key = "<leader>sp";
      action = lib.nixvim.mkRaw "function() require('spectre').open_file_search({ select_word = true }) end";
      options.desc = "Search current file";
    }
    {
      key = "<leader>V";
      action = lib.nixvim.mkRaw ''
        function()
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            if venn_enabled == 'nil' then
                vim.b.venn_enabled = true
                vim.cmd [[setlocal ve=all]]
                -- draw a line on HJKL keystokes
                vim.api.nvim_buf_set_keymap(0, 'n', 'J', '<C-v>j:VBox<CR>', { noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<C-v>k:VBox<CR>', { noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', 'L', '<C-v>l:VBox<CR>', { noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', 'H', '<C-v>h:VBox<CR>', { noremap = true })
                -- draw a box by pressing "f" with visual selection
                vim.api.nvim_buf_set_keymap(0, 'v', 'f', ':VBox<CR>', { noremap = true })
            else
                vim.cmd [[setlocal ve=]]
                vim.api.nvim_buf_del_keymap(0, 'n', 'J')
                vim.api.nvim_buf_del_keymap(0, 'n', 'K')
                vim.api.nvim_buf_del_keymap(0, 'n', 'L')
                vim.api.nvim_buf_del_keymap(0, 'n', 'H')
                vim.api.nvim_buf_del_keymap(0, 'v', 'f')
                vim.b.venn_enabled = nil
            end
        end
      '';
      options.desc = "Toggle Venn";
    }
  ];
}
