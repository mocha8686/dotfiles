{
  config,
  pkgs,
  inputs,
  ...
}: let
  neopywal = pkgs.vimUtils.buildVimPlugin {
    name = "neopywal";
    src = inputs.neopywal;
    doCheck = false;
  };
in {
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mocha";
  home.homeDirectory = "/home/mocha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  i18n.inputMethod.fcitx5.settings = {
    globalOptions = {
      "Hotkey/TriggerKeys" = {
        "0" = "Control+Shift+space";
        "1" = "Zenkaku_Hankaku";
        "2" = "Hangul";
      };

      "Hotkey/ActivateKeys"."0" = "Hangul_Hanja";
      "Hotkey/DeactivateKeys"."0" = "Hangul_Romaja";
      "Hotkey/AltTriggerKeys"."0" = "Shift_L";
      "Hotkey/EnumerateGroupForwardKeys"."0" = "Super+space";
      "Hotkey/EnumerateGroupBackwardKeys"."0" = "Shift+Super+space";
      "Hotkey/PrevPage"."0" = "Up";
      "Hotkey/NextPage"."0" = "Down";
      "Hotkey/PrevCandidate"."0" = "Shift+Tab";
      "Hotkey/NextCandidate"."0" = "Tab";
      "Hotkey/TogglePreedit"."0" = "Control+Alt+P";

      "Behavior" = {
        "ActiveByDefault" = "False";
        "resetStateWhenFocusIn" = "No";
        "ShareInputState" = "No";
        "PreeditEnabledByDefault" = "True";
        "ShowInputMethodInformation" = "True";
        "showInputMethodInformationWhenFocusIn" = "False";
        "CompactInputMethodInformation" = "True";
        "ShowFirstInputMethodInformation" = "True";
        "DefaultPageSize" = "5";
        "OverrideXkbOption" = "False";
        "CustomXkbOption" = "";
        "EnabledAddons" = "";
        "DisabledAddons" = "";
        "PreloadInputMethod" = "True";
        "AllowInputMethodForPassword" = "False";
        "ShowPreeditForPassword" = "False";
        "AutoSavePeriod" = "30";
      };
    };
    inputMethod = {
      "GroupOrder"."0" = "Default";
      "Groups/0" = {
        "Name" = "Default";
        "Default Layout" = "us";
        "DefaultIM" = "mozc";
      };
      "Groups/0/Items/0" = {
        "Name" = "keyboard-us";
        "Layout" = "";
      };
      "Groups/0/Items/1" = {
        "Name" = "mozc";
        "Layout" = "";
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; let
    nixDotDir = "~/dotfiles/nix/";
    rebuild = pkgs.writeShellScriptBin "rebuild" ''
      pushd ${nixDotDir}
      "$EDITOR" configuration.nix home.nix flake.nix

      git add -A

      if git diff --cached --quiet *.nix **/*.nix; then
        echo "No changes detected."
        popd
        exit 0
      fi

      git diff --cached -U0 *.nix **/*.nix

      nh os switch -a . | tee nixos-switch.log
      if [[ ''${PIPESTATUS[0]} > 0 ]]; then
        echo "Rebuild failed."
        popd
        notify-send -e "Rebuild" "Rebuild failed.\nSee console for more info."
        exit 1
      fi

      gen=$(nixos-rebuild list-generations | grep True | awk '{printf "gen %s\nnixos %s :: kernel %s\n", $1, $4, $5}')
      git commit -m "$gen"
      popd

      notify-send -e "Rebuild" "Rebuild successful.\n$gen"
    '';
  in [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #	 echo "Hello, ${config.home.username}!"
    # '')

    rebuild

    bat
    btop
    delta
    eza
    fd
    file
    fzf
    ripgrep
    tldr
    zoxide

    imv
    lazygit
    rclone
    starship

    fuzzel
    inputs.qml-niri.packages.${pkgs.system}.quickshell
    libnotify
    swww
    wallust

    krita
    libreoffice
    prismlauncher
    qalculate-qt
    vesktop

    ffmpeg
    pavucontrol
    playerctl

    python3

    texlivePackages.nunito
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = let
    dotsym = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
  in {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #	 org.gradle.console=verbose
    #	 org.gradle.daemon.idletimeout=3600000
    # '';

    # ".config/nvim".source = ~/dotfiles/nvim;
    ".config/nvim/snippets".source = dotsym "nvim/mini-snippets";

    ".gitconfig".source = dotsym "git/.gitconfig";
    ".zshrc.ext".source = dotsym "zsh/.zshrc";
    ".config/kitty".source = dotsym "kitty";
    ".swww".source = dotsym "swww/.swww";
    ".config/niri".source = dotsym "niri";
    ".config/quickshell".source = dotsym "quickshell";
    ".config/starship.toml".source = dotsym "starship/starship.toml";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #	~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #	~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #	/etc/profiles/per-user/mocha/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraPlugins = with pkgs.vimPlugins; [
      vim-cool
      venn-nvim
      focus-nvim
      neopywal
    ];

    imports = [./programs/nixvim.nix];
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      source ~/.zshrc.ext
    '';
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 10";
    };
    flake = "${config.home.homeDirectory}/dotfiles/nix";
  };

  systemd.user.services.drive-Documents = {
    Unit = {
      Description = "GDrive Documents mount.";
      After = ["network-online.target"];
    };
    Service = let
      localDir = "%h/Documents/Drive";
      driveDir = "Documents";
    in {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p \"${localDir}\"";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=\"%h/.config/rclone/rclone.conf\" --vfs-cache-mode=full --vfs-read-ahead=16M mount \"drive:${driveDir}\" \"${localDir}\"";
      ExecStop = "/run/wrappers/bin/fusermount -u \"${localDir}/%i\"";
    };
    Install.WantedBy = ["default.target"];
  };

  systemd.user.services.drive-Images = {
    Unit = {
      Description = "GDrive Images mount.";
      After = ["network-online.target"];
    };
    Service = let
      localDir = "%h/Pictures/Drive";
      driveDir = "Images";
    in {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p \"${localDir}\"";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=\"%h/.config/rclone/rclone.conf\" --vfs-cache-mode=full --vfs-read-ahead=16M mount \"drive:${driveDir}\" \"${localDir}\"";
      ExecStop = "/run/wrappers/bin/fusermount -u \"${localDir}/%i\"";
    };
    Install.WantedBy = ["default.target"];
  };

  # Dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita";
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  qt = {
    enable = true;
    style.name = "Adwaita";
  };

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = "gtk";
  };
}
