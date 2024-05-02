{ self, config, pkgs, lib, ... }: {
  nix.settings = {
    trusted-users = [ "@admin" ];
    substituters = [ "https://cache.nixos.org/" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

    experimental-features = "nix-command flakes";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    git

    pre-commit
    git-crypt

    ov

    nodejs_20
    nodePackages.bash-language-server
  ];

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Make Fish the default shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;

  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = ''
    for p in (string split : ${config.environment.systemPath})
      if not contains $p $fish_user_paths
        set -g fish_user_paths $fish_user_paths $p
      end
    end
  '';
  environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  # Networking
  networking.knownNetworkServices = [
    "Ethernet"
    "Wi-Fi"
    "Bluetooth PAN"
    "iPhone USB"
    "Thunderbolt Bridge"
  ];

  networking.dns = [
    "1.1.1.1"
    "2606:4700:4700::1111"
    "8.8.8.8"
    "2001:4860:4860::8888"
  ];
}
