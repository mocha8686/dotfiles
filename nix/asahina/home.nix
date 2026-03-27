{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../home.nix
  ];

  home.homeDirectory = "/home/mocha";

  home.packages = with pkgs; [
    # Graphical
    krita
    libreoffice
    obsidian
    prismlauncher
    qalculate-qt
    swww
    tetrio-desktop
    vesktop

    # Coding
    python3

    # REAPER
    fira
    reaper
    reaper-reapack-extension
    reaper-sws-extension
    userFonts.frozenCrystal
    carla
    lsp-plugins
    sfizz-ui
    vital
    yabridge
    zam-plugins
    calf
  ];

  home.file =
    let
      dotsym = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
    in
    {
      ".swww".source = dotsym "swww/.swww";
      ".config/niri".source = dotsym "niri";
      ".config/quickshell".source = dotsym "quickshell";
      ".config/wallust".source = dotsym "wallust";
    };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    size = 64;
    name = "Ichika";
    package = inputs.ichikaCursor.packages.${pkgs.system}.ichikaCursor;
  };

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

      "application/pdf" = "org.gnome.Evince.desktop";
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


  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
