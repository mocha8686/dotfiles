{
  config,
  pkgs,
  inputs,
  ...
}:
let
  neopywal = pkgs.vimUtils.buildVimPlugin {
    name = "neopywal";
    src = inputs.neopywal;
    doCheck = false;
  };

  remoteName = "drive";
  bisyncInitialize = "10s";
  bisyncPeriod = "5min";

  createBisync =
    configPath: remoteDir: localDir:
    "${pkgs.rclone}/bin/rclone bisync \"${remoteName}:${remoteDir}\" \"${localDir}\" --config=\"${configPath}\" --create-empty-src-dirs --compare=size,modtime,checksum --slow-hash-sync-only --resilient --recover --fix-case --conflict-resolve=newer --conflict-loser=delete --max-lock=2m -v";
  createResync =
    remoteDir: localDir:
    "${createBisync "$HOME/.config/rclone/rclone.conf" remoteDir localDir} --resync";

  rsyncService = remoteDir: localDir: {
    Unit.Description = "rclone bisync for ${remoteName}:${remoteDir}";
    Service.Type = "oneshot";
    Service.ExecStart = createBisync "%h/.config/rclone/rclone.conf" remoteDir localDir;
  };
  rsyncTimer = remoteDir: {
    Unit.Description = "rclone bisync for ${remoteName}:${remoteDir} every ${bisyncPeriod}";
    Unit.After = "network-online.target";
    Timer.OnBootSec = bisyncInitialize;
    Timer.OnUnitActiveSec = bisyncPeriod;
    Install.WantedBy = [
      "timers.target"
    ];
  };
in
{
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
  home.packages =
    with pkgs;
    let
      userFonts = inputs.fonts.packages.${pkgs.system};
      nixDotDir = "~/dotfiles/nix/";
      rebuild = pkgs.writeShellScriptBin "rebuild" ''
        cd ${nixDotDir} || {
          echo "Failed to find nix dotfile directory."
          exit 1
        }
        "$EDITOR" configuration.nix home.nix flake.nix

        git add -A

        if git diff --cached --quiet ./flake.lock ./*.nix ./**/*.nix; then
          echo "No changes detected."
          exit 0
        fi

        git diff --cached -U0 ./*.nix ./**/*.nix

        if ! git diff --cached --quiet ./flake.lock; then
          echo "====================="
          echo "= Lockfile updated. ="
          echo "====================="
        fi

        nh os switch -a . | tee nixos-switch.log
        if [[ ''${PIPESTATUS[0]} -gt 0 ]]; then
          echo "Rebuild failed."
          notify-send -e "Rebuild" "Rebuild failed.\nSee console for more info."
          exit 1
        fi

        gen=$(nixos-rebuild list-generations | grep True | awk '{printf "gen %s\nnixos %s :: kernel %s\n", $1, $4, $5}')
        git commit -m "$gen"

        notify-send -e "Rebuild" "Rebuild successful.\n$gen"
      '';
      resync = pkgs.writeShellScriptBin "resync" ''
        ${createResync "Documents" "${config.home.homeDirectory}/Documents/Drive"}
        ${createResync "Images" "${config.home.homeDirectory}/Pictures/Drive"}
      '';
    in
    [
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

      # Shell Scripts
      rebuild
      resync

      # Terminal
      bat
      btop
      delta
      eza
      fd
      ffmpeg
      file
      fzf
      lazygit
      nmap
      rclone
      ripgrep
      starship
      tldr
      zoxide

      # Graphical
      krita
      libreoffice
      obsidian
      prismlauncher
      qalculate-qt
      qdirstat
      swww
      vesktop
      # discord
      wallust

      # Coding
      python3

      # Fonts
      userFonts.rajdhani

      # REAPER
      fira
      reaper
      reaper-reapack-extension
      reaper-sws-extension
      userFonts.frozenCrystal

      tetrio-desktop
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file =
    let
      dotsym = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
    in
    {
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

    imports = [ ./programs/nixvim.nix ];
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

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    serif = [
      "Liberation Serif"
    ];
    sansSerif = [
      "Rajdhani"
    ];
    monospace = [
      "Iosevka Nerd Font Mono"
      "Iosevka Nerd Font"
      "Iosevka"
    ];
  };

  # rclone Drive

  systemd.user.timers.drive-Documents = rsyncTimer "Documents";
  systemd.user.services.drive-Documents = rsyncService "Documents" "%h/Documents/Drive";

  systemd.user.timers.drive-Images = rsyncTimer "Images";
  systemd.user.services.drive-Images = rsyncService "Images" "%h/Pictures/Drive";

  systemd.user.tmpfiles.rules =
    let
      createHomeDirRule = dir: "d %h/${dir} - - - - -";
    in
    [
      (createHomeDirRule "Documents/Drive")
      (createHomeDirRule "Pictures/Drive")
    ];

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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications =
    let
      archiveTool = "org.kde.ark.desktop";
      imageViewer = "imv-dir.desktop";
      avViewer = "mpv.desktop";
    in
    {
      "application/gzip" = archiveTool;
      "application/vnd.rar" = archiveTool;
      "application/x-7z-compressed" = archiveTool;
      "application/x-bzip" = archiveTool;
      "application/x-bzip2" = archiveTool;
      "application/x-tar" = archiveTool;
      "application/zip" = archiveTool;

      "image/apng" = imageViewer;
      "image/avif" = imageViewer;
      "image/bmp" = imageViewer;
      "image/jpeg" = imageViewer;
      "image/png" = imageViewer;
      "image/svg+xml" = imageViewer;
      "image/tiff" = imageViewer;
      "image/vnd.microsoft.icon" = imageViewer;
      "image/webp" = imageViewer;

      "application/ogg" = avViewer;
      "audio/aac" = avViewer;
      "audio/midi" = avViewer;
      "audio/ogg" = avViewer;
      "audio/wav" = avViewer;
      "audio/webm" = avViewer;
      "audio/x-midi" = avViewer;
      "video/mp4" = avViewer;
      "video/mpeg" = avViewer;
      "video/ogg" = avViewer;
      "video/webm" = avViewer;
      "video/x-msvideo" = avViewer;
    };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
