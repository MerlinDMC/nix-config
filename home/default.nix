{ nixpkgs, ... }: {

  home.packages = with nixpkgs; [
    # shell
    fishPlugins.pure

    # basics
    coreutils
    mosh
    xz
    zstd

    jq
    yq
    ripgrep

    kubectl
    kubernetes-helm
    stern
    direnv
    nix-direnv
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "MerlinDMC";
    userEmail = "MerlinDMC@me.com";
  };

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = {
        description = "Greeting to show when starting a fish shell";
        body = "";
      };
      mkdcd = {
        description = "Make a directory tree and enter it";
        body = "mkdir -p $argv[1]; and cd $argv[1]";
      };
    };
    shellInit = ''
      set -U fish_user_paths \
        /nix/var/nix/profiles/per-user/$USER/home-manager/home-path/bin \
        /run/current-system/sw/bin \
        $HOME/.exenv/shims \
        $HOME/.goenv/shims \
        $HOME/.rbenv/shims \
        $HOME/.pyenv/shims \
        $HOME/.nodenv/shims \
        $HOME/.cargo/bin \
        $HOME/go/bin \
        $HOME/.local/bin \
        $HOME/.krew/bin \
        /opt/homebrew/bin \
        /usr/local/bin \
        /usr/local/sbin \
        /usr/bin \
        /bin \
        /usr/sbin \
        /sbin
      set -U GOPATH $HOME/go

      set -U TF_PLUGIN_CACHE_DIR "$HOME/.terraform.d/plugin-cache"

      # kubectl configurations
      set -l KUBECONFIGS $HOME/.kube/config
      for name in $HOME/.kube/kubeconfig-*.yaml;
          set -a KUBECONFIGS $name
      end
      set -Ux KUBECONFIG (string join ':' $KUBECONFIGS)
    '';
  };

  home.file = {
    ".gitconfig".text = ''
    [user]
      name = Daniel Malon
      email = daniel.malon@me.com
      signingKey = FCB97856BBA5B14D

    [commit]
      gpgsign = true

    [github]
      user = MerlinDMC

    [diff]
      compactionHeuristic = true

    [rerere]
      enabled = true

    [color]
      ui = true

    [push]
      default = simple

    [pull]
      rebase = true

    [core]
      excludesfile = /Users/daniel/.gitignore_global
    '';

    ".gitignore_global".text = ''
    *~
    *.swp
    *.swo
    .DS_Store
    '';

    # Spacemacs
    # ".emacs.d" = {
    #   source = nixpkgs.fetchFromGitHub {
    #     owner = "syl20bnr";
    #     repo = "spacemacs";
    #     rev = "f5489758417a7d75d0319b5c9f537d93f106a773";
    #     sha256 = "03jcjs0z8z20s34x04anl6x8g8pwz4bknzkz10p1zzljq1fn7qyl";
    #   };
    #   recursive = true;
    # };
  };
}
