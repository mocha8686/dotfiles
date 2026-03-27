{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  neopywal = pkgs.vimUtils.buildVimPlugin {
    name = "neopywal";
    src = inputs.neopywal;
    doCheck = false;
  };

  remoteName = "drive";
  bisyncInitializeSecs = 10;
  bisyncPeriodSecs = 300;

  createBisync =
    configPath: remoteDir: localDir:
    [
      "${pkgs.rclone}/bin/rclone"
      "bisync"
      "\"${remoteName}:${remoteDir}\""
      "\"${localDir}\""
      "--config=\"${configPath}\""
      "--create-empty-src-dirs"
      "--compare=size,modtime,checksum"
      "--slow-hash-sync-only"
      "--resilient"
      "--recover"
      "--fix-case"
      "--conflict-resolve=newer"
      "--conflict-loser=delete"
      "--max-lock=2m"
      "-v"
    ];
  createResync =
    remoteDir: localDir:
    "${lib.concatStringsSep " " (createBisync "$HOME/.config/rclone/rclone.conf" remoteDir localDir)} --resync";

  rcloneService = remoteDir: localDir: {
    Unit.Description = "rclone bisync for ${remoteName}:${remoteDir}";
    Service.Type = "oneshot";
    Service.ExecStart = lib.concatStringsSep " " (createBisync "%h/.config/rclone/rclone.conf" remoteDir localDir);
  };
  rcloneTimer = remoteDir: {
    Unit.Description = "rclone bisync for ${remoteName}:${remoteDir} every ${bisyncPeriodSecs / 60}min";
    Unit.After = "network-online.target";
    Timer.OnBootSec = "${bisyncInitializeSecs}s";
    Timer.OnUnitActiveSec = "${bisyncPeriodSecs}s";
    Install.WantedBy = [
      "timers.target"
    ];
  };
  rcloneLaunchAgent = label: remoteDir: localDir: {
    enable = true;
    config =
    let
      bisync = createBisync "${config.home.homeDirectory}/.config/rclone/rclone.conf" remoteDir localDir;
    in
    {
      Label = label;
      Program = builtins.elemAt bisync 0;
      ProgramArguments = bisync;
      RunAtLoad = true;
      StartInterval = bisyncPeriodSecs;
      StandardErrorPath = "${config.home.homeDirectory}/.local/share/${label}.stderr";
      StandardOutPath = "${config.home.homeDirectory}/.local/share/${label}.stdout";
    };
  };
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mocha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

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

        OS="$(uname)"
        NOTIFY="$(command -v notify-send)"


        if [[ $OS == Darwin ]]; then
          FILES="flake.nix akiyama/* home.nix configuration.nix"
        else
          FILES="flake.nix asahina/* home.nix configuration.nix"
        fi
        "$EDITOR" $FILES

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


        if [[ $OS == Darwin ]]; then
          CMD="darwin"
        else
          CMD="os"
        fi
        nh $CMD switch -a . | tee nixos-switch.log

        if [[ ''${PIPESTATUS[0]} -gt 0 ]]; then
          echo "Rebuild failed."
          if command -v notify-send; then
            notify-send -e "Rebuild" "Rebuild failed.\nSee console for more info."
          fi
          exit 1
        fi

        if [[ $OS == Darwin ]]; then
          MSG="darwin switch"
        else
          MSG=$(nixos-rebuild list-generations | grep True | awk '{printf "gen %s\nnixos %s :: kernel %s\n", $1, $4, $5}')
        fi
        git commit -m "$MSG"

        if command -v notify-send; then
          notify-send -e "Rebuild" "Rebuild successful.\n$gen"
        fi
      '';
      resync = pkgs.writeShellScriptBin "resync" ''
        ${createResync "Documents" "${config.home.homeDirectory}/Documents/Drive"}
        ${createResync "Images" "${config.home.homeDirectory}/Pictures/Drive"}

        OS="$(uname)"
        if [[ $OS != Darwin ]]; then
          ${createResync "REAPER/Config" "${config.home.homeDirectory}/.config/REAPER"}
          ${createResync "REAPER/Samples" "${config.home.homeDirectory}/Music/Samples/Drive"}
          ${createResync "REAPER/VitalPresets" "${config.home.homeDirectory}/.local/share/vital/User/Presets"}
        fi
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
      obsidian
      prismlauncher
      qalculate-qt
      vesktop
      wallust

      # Fonts
      userFonts.rajdhani

      # Games
      tetrio-desktop
    ] ++ [
      inputs.globalprotect-openconnect.packages.${pkgs.stdenv.hostPlatform.system}.default
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

  systemd = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    user.timers.drive-Documents = rcloneTimer "Documents";
    user.services.drive-Documents = rcloneService "Documents" "%h/Documents/Drive";

    user.timers.drive-Images = rcloneTimer "Images";
    user.services.drive-Images = rcloneService "Images" "%h/Pictures/Drive";

    user.timers.drive-REAPERConfig = rcloneTimer "REAPER/Config";
    user.services.drive-REAPERConfig = rcloneService "REAPER/Config" "%h/.config/REAPER";

    user.timers.drive-Samples = rcloneTimer "REAPER/Samples";
    user.services.drive-Samples = rcloneService "REAPER/Samples" "%h/Music/Samples/Drive";

    user.timers.drive-VitalPresets = rcloneTimer "REAPER/VitalPresets";
    user.services.drive-VitalPresets = rcloneService "REAPER/VitalPresets" "%h/.local/share/vital/User/Presets";

    user.tmpfiles.rules =
      let
        createHomeDirRule = dir: "d %h/${dir} - - - - -";
      in
      [
        (createHomeDirRule "Documents/Drive")
        (createHomeDirRule "Pictures/Drive")
      ];
  };

  launchd = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    agents.drive-Documents = rcloneLaunchAgent "drive-Documents" "Documents" "${config.home.homeDirectory}/Documents/Drive";
    agents.drive-Images = rcloneLaunchAgent "drive-Images" "Images" "${config.home.homeDirectory}/Pictures/Drive";
  };
}
