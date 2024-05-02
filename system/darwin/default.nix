{ self, config, pkgs, lib, ... }: {
  imports = [
    ../common.nix
  ];

  system.stateVersion = 4;

  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    dock.minimize-to-application = true;
    dock.magnification = true;
    dock.largesize = 64;
    dock.tilesize = 24;
    dock.showhidden = true;

    finder.AppleShowAllFiles = true;
    finder.FXPreferredViewStyle = "Nlsv";

    loginwindow.DisableConsoleAccess = true;
    loginwindow.GuestEnabled = false;

    screensaver.askForPassword = true;
    screensaver.askForPasswordDelay = 10;

    trackpad.Clicking = true;
  };

  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

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
      "d12frosted/emacs-plus"
      "homebrew/cask-versions"
      "homebrew/cask-fonts"
      "nodenv/nodenv"
    ];

    masApps = {
      # "Magnet" = 441258766;
      "Infuse" = 1136220934;
      "1Password for Safari" = 1569813296;
    };

    brews = [
      "pinentry-mac"

      "goenv"
      "tfenv"
      "pyenv"

      "yt-dlp"
      "ffmpeg"

      {
        name = "d12frosted/emacs-plus/emacs-plus@30";
        args = [
          "with-modern-doom3-icon"
          "with-compress-install"
          # "with-native-comp"
        ];
      }

      # {
      #   name = "railwaycat/emacsmacport/emacs-mac";
      #   args = [
      #     "with-mac-metal"
      #     # "with-native-compilation"
      #     "with-starter"
      #     "with-spacemacs-icon"
      #   ];
      # }
    ];

    casks = [
      "rectangle-pro"
      "1password"
      "firefox@developer-edition"
      "forklift"
      "keka"
      "slack"
      "vlc"
      "iterm2"
      "sublime-text"
      "jetbrains-toolbox"
      "omnifocus"
      "skype"
      "cloudflare-warp"
      "utm"
    ];

    extraConfig = ''
      cask_args appdir: "~/Applications", require_sha: true

      cask "google-chrome", args: { require_sha: false }
    '';
  };
}
