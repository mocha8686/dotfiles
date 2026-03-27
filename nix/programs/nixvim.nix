{ lib, ... }:
{
  plugins.todo-comments.enable = true;
  plugins.gitsigns.enable = true;
  plugins.git-conflict.enable = true;
  plugins.vim-matchup.enable = true;
  plugins.leetcode.enable = true;

  plugins.lspconfig.enable = true;

  plugins.spectre.enable = true;

  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" "diff" "diagnostics" ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            symbols = {
              readonly = "";
            };
          }
        ];
        lualine_x = [ "encoding" "fileformat" "filetype" ];
        lualine_y = [ "progress" ];
        lualine_z = [
          {
            __unkeyed-1 = "location";
            fmt = lib.nixvim.mkRaw ''
              function(str)
                for l, c in string.gmatch(str, "(%d+):(%d+)") do
                  return "" .. l .. " " .. c
                end
              end
            '';
          }
        ];
      };
    };
  };

  plugins.toggleterm = {
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

  plugins.ccc = {
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

  plugins.mini = {
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
            { mode = 'n', keys = '<leader>v', desc = '+Leet' },

            require('mini.clue').gen_clues.builtin_completion(),
            require('mini.clue').gen_clues.g(),
            require('mini.clue').gen_clues.marks(),
            require('mini.clue').gen_clues.registers(),
            require('mini.clue').gen_clues.windows(),
          }
        '';
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

  lsp.inlayHints.enable = true;

  lsp.servers = {
    astro.enable = true;
    biome.enable = true;
    clangd.enable = true;
    cssls.enable = true;
    emmet_ls.enable = true;
    eslint.enable = true;
    html.enable = true;
    jsonls.enable = true;
    nil_ls.enable = true;
    qmlls.enable = true;
    rust_analyzer.enable = true;
    statix.enable = true;
    stylelint.enable = true;
    ts_ls.enable = true;
  };

  lsp.keymaps = [
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
      key = "<leader>lr";
      action = lib.nixvim.mkRaw "function() MiniExtra.pickers.lsp { scope = 'references' } end";
      options.desc = "Pick references";
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
    -- Setup neopywal
    require('neopywal').setup { use_wallust = true }
    vim.cmd.colorscheme 'neopywal'

    -- Setup focus.nvim
    require('focus').setup()

    -- Completion keymaps
    local map_multistep = require('mini.keymap').map_multistep
    map_multistep('i', '<Tab>', { 'pmenu_next' })
    map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
    map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
    map_multistep('i', '<BS>', { 'minipairs_bs' })

    -- <CR> accepts first completion
    _G.cr_action = function()
      complete_info = vim.fn.complete_info()
      if #complete_info['items'] > 0 then
        if complete_info['selected'] == -1 then
          return '<C-n><C-y>'
        else
          return '<C-y>'
        end
      end
      return MiniPairs.cr()
    end
    vim.keymap.set('i', '<CR>', 'v:lua.cr_action()', { expr = true })

    -- Set highlight group for tabline
    vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "IncSearch" })

    -- Autoload local nvimconfig.lua
    local project_config_module_name = 'nvimconfig'
    local function load_project_config()
      if vim.fn.filereadable(project_config_module_name .. '.lua') ~= 0 then
        require('./' .. project_config_module_name)
      end
    end
    load_project_config()
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
    completeopt = "menuone,noselect,nosort,fuzzy";
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
    {
      key = "<leader>v'";
      action = "<Cmd>Leet run<CR>";
      options.desc = "Run solution";
    }
    {
      key = "<leader>v<CR>";
      action = "<Cmd>Leet submit<CR>";
      options.desc = "Submit solution";
    }
    {
      key = "<leader>vc";
      action = "<Cmd>Leet console<CR>";
      options.desc = "Open console";
    }
    {
      key = "<leader>vd";
      action = "<Cmd>Leet desc<CR>";
      options.desc = "View question description";
    }
    {
      key = "<leader>vi";
      action = "<Cmd>Leet info<CR>";
      options.desc = "View question info";
    }
    {
      key = "<leader>vl";
      action = "<Cmd>Leet lang<CR>";
      options.desc = "Change language";
    }
    {
      key = "<leader>vo";
      action = "<Cmd>Leet open<CR>";
      options.desc = "Open problem in browser";
    }
    {
      key = "<leader>vr";
      action = "<Cmd>Leet random<CR>";
      options.desc = "Random problem";
    }
    {
      key = "<leader>vt";
      action = "<Cmd>Leet tabs<CR>";
      options.desc = "View Leet tabs";
    }
    {
      key = "<leader>vv";
      action = "<Cmd>Leet<CR>";
      options.desc = "Open menu";
    }
    {
      key = "<leader>vy";
      action = "<Cmd>Leet daily<CR>";
      options.desc = "Daily problem";
    }
  ];
}
