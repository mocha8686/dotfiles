{ pkgs, lib, inputs, ... }:
{
  plugins = {
    mini-diff.enable = true;
    mini-git.enable = true;
    mini-icons = {
      enable = true;
      mockDevIcons = true;
    };

    mini-statusline = {
      enable = true;
      settings = let
        fn = lib.nixvim.utils.mkRaw ''
function()
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
  local git           = MiniStatusline.section_git({ trunc_width = 40 })
  local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
  local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
  local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
  local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
  -- local location      = MiniStatusline.section_location({ trunc_width = 75 })
  local location      = '%l %v'
  local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

  return MiniStatusline.combine_groups({
    { hl = mode_hl,                  strings = { string.upper(mode) } },
    { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = mode_hl,                  strings = { search, location } },
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

  extraConfigLua = ''
    require('neopywal').setup { use_wallust = true }
    vim.cmd.colorscheme 'neopywal'
  '';

  global = {
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
    wrap = false;
    fillchars = {
      stl = " ";
      stlnc = " ";
      wbr = " ";
    };
  };

  autoGroups = {
    "number_focus".clear = true;
  };

  autoCmd = [
    {
      event = [ "BufEnter" "FocusGained" "InsertLeave" ];
      pattern = "*";
      command = "set relativenumber";
      group = "number_focus";
    }
    {
      event = [ "BufLeave" "FocusLost" "InsertEnter" ];
      pattern = "*";
      command = "set norelativenumber";
      group = "number_focus";
    }
  ];

  keymaps = [
    {
      key = "<C-h>";
      action = "<Cmd>wincmd h<CR>";
      mode = [ "n" "t" ];
      options = {
        desc = "Select window to the left";
      };
    }
    {
      key = "<C-j>";
      action = "<Cmd>wincmd j<CR>";
      mode = [ "n" "t" ];
      options = {
        desc = "Select window below";
      };
    }
    {
      key = "<C-k>";
      action = "<Cmd>wincmd k<CR>";
      mode = [ "n" "t" ];
      options = {
        desc = "Select window above";
      };
    }
    {
      key = "<C-l>";
      action = "<Cmd>wincmd l<CR>";
      mode = [ "n" "t" ];
      options = {
        desc = "Select window to the right";
      };
    }
    {
      key = "<leader>q";
      action = "<Cmd>wincmd q<CR>";
      options = {
        desc = "Close window";
      };
    }
    {
      key = "<Tab>";
      action = "<Cmd>bn<CR>";
      options = {
        desc = "Select next buffer";
      };
    }
    {
      key = "<S-Tab>";
      action = "<Cmd>bp<CR>";
      options = {
        desc = "Select previous buffer";
      };
    }
    {
      key = "]q";
      action = "<Cmd>cn<CR>";
      options = {
        desc = "Next quickfix";
      };
    }
    {
      key = "[q";
      action = "<Cmd>cp<CR>";
      options = {
        desc = "Previous quickfix";
      };
    }
    {
      key = "<Up>";
      action = "<Cmd>gk<CR>";
      mode = [ "n" "v" ];
    }
    {
      key = "<Down>";
      action = "<Cmd>gj<CR>";
      mode = [ "n" "v" ];
    }
    {
      key = "<C-Left>";
      action = "<Cmd>g0<CR>";
      mode = [ "n" "v" ];
    }
    {
      key = "<C-Right>";
      action = "<Cmd>g$<CR>";
      mode = [ "n" "v" ];
    }
  ];
}
