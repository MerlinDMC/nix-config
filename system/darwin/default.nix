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
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [
      "railwaycat/emacsmacport"
      "homebrew/cask-versions"
      "homebrew/cask-fonts"
      "homebrew/cask"
      "nodenv/nodenv"
    ];

    masApps = {
      "Magnet" = 441258766;
      "Infuse" = 1136220934;
      "1Password for Safari" = 1569813296;
    };

    brews = [
      "fish"

      "pinentry-mac"

      "tfenv"
      "pyenv"

      "lima"
    ];

    casks = [
      "1password"
      "firefox-developer-edition"
      "forklift"
      "slack"
      "vlc"
      "iterm2"
      "sublime-text"
      "jetbrains-toolbox"
      "transmission"
      "keybase"
      "emacs-mac-spacemacs-icon"
      "omnifocus"
      "vnc-viewer"
      "autodesk-fusion360"
      "prusaslicer"
      "skype"
      "warp"
      "cloudflare-warp"
      "utm"
    ];

    extraConfig = ''
      cask_args appdir: "~/Applications", require_sha: true

      cask "google-chrome", args: { require_sha: false }
    '';
  };
}
