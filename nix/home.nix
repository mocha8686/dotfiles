{ config, pkgs, inputs, ... }:

let
	neopywal = pkgs.vimUtils.buildVimPlugin {
		name = "neopywal";
		src = inputs.neopywal;
		doCheck = false;
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

	# The home.packages option allows you to install Nix packages into your
	# environment.
	home.packages = [
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

		pkgs.btop
		pkgs.fuzzel
		pkgs.wallust
		pkgs.swww

		pkgs.lazygit
		pkgs.delta
		pkgs.zoxide

		pkgs.file
		pkgs.eza
		pkgs.bat
		pkgs.fd
		pkgs.fzf
		pkgs.ripgrep
		pkgs.tldr

		pkgs.vesktop
		pkgs.prismlauncher
	];

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = let
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

		".gitconfig".source = dotsym "git/.gitconfig";
		".zshrc.ext".source = dotsym "zsh/.zshrc";
		".config/kitty".source = dotsym "kitty";
		".config/swww".source = dotsym "swww";
		".config/niri".source = dotsym "niri";
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
		extraPlugins = [
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

	systemd.user.services.swww-daemon = {
		Unit.Description = "swww daemon";
		Service.ExecStart = "${pkgs.swww}/bin/swww-daemon";
	};

	systemd.user.timers.swww-daemon = {
		Unit = {
			Description = "swww daemon";
			After = [ "graphical.target" ];
		};
		Timer.OnBootSec="2s";
		Install.WantedBy = [ "timers.target" ];
	};
}
