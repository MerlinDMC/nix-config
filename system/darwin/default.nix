{ config, pkgs, lib, ... }: {
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix
  ];

  # Networking
  networking.knownNetworkServices =
    [ "Ethernet" "Wi-Fi" "Bluetooth PAN" "iPhone USB" "Thunderbolt Bridge" ];
  networking.dns =
    [ "1.1.1.1" "2606:4700:4700::1111" "8.8.8.8" "2001:4860:4860::8888" ];

  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "railwaycat/emacsmacport"
      "homebrew/cask-versions"
      "homebrew/cask-fonts"
      "homebrew/cask"
      "nodenv/nodenv"
    ];

    masApps = {
      "1Password" = 1333542190;
      "Magnet" = 441258766;
    };

    brews = [
      "fish"
      "gnupg"
      "git-crypt"
      "pinentry-mac"

      "coreutils"
      "pbzip2"
      "xz"
      "zstd"
      "p7zip"

      "ripgrep"

      "tfenv"
      "pyenv"
    ];

    casks = [
      "forklift"
      "slack"
      "vlc"
      "jellyfin-media-player"
      "iterm2"
      "sublime-text"
      "jetbrains-toolbox"
      "transmission"
      "keybase"
      "emacs-mac-spacemacs-icon"
      "omnifocus"
      "vnc-viewer"
    ];

    extraConfig = ''
      cask_args appdir: "~/Applications", require_sha: true

      cask "google-chrome", args: { require_sha: false }
    '';
  };
}
