{ pkgs, inputs, ... }:
{
  plugins = {
    mini-statusline = {
      enable = true;
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
