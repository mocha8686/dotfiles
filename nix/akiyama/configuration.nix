{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../configuration.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    git
    grandperspective
    kitty
    rectangle
  ];

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The playform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "mocha";
  users.users.mocha.home = "/Users/mocha";

  homebrew = {
    enable = true;
    casks = [
      "vivaldi"
      "altserver"
    ];
  };
}
