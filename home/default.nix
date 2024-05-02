{ homeDirectory, nixpkgs, home-manager, ... }: {

  home.stateVersion = "22.05";

  home.packages = with nixpkgs; [
    # shell
    fishPlugins.fishtape
    #fishPlugins.pure
    fishPlugins.hydro

    # basics
    coreutils
    mosh
    pbzip2
    p7zip
    xz
    zstd

    jq
    yq
    ripgrep

    aria
    goreleaser

    kubectl
    kubernetes-helm
    stern
  ];

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Daniel Malon";
    userEmail = "daniel.malon@me.com";
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
        ${homeDirectory}/.exenv/shims \
        ${homeDirectory}/.goenv/shims \
        ${homeDirectory}/.rbenv/shims \
        ${homeDirectory}/.pyenv/shims \
        ${homeDirectory}/.nodenv/shims \
        ${homeDirectory}/.cargo/bin \
        ${homeDirectory}/go/bin \
        ${homeDirectory}/.local/bin \
        ${homeDirectory}/.krew/bin \
        /opt/homebrew/bin \
        /usr/local/bin \
        /usr/local/sbin \
        /usr/bin \
        /bin \
        /usr/sbin \
        /sbin
      set -U GOPATH ${homeDirectory}/go

      set -U TF_PLUGIN_CACHE_DIR "${homeDirectory}/.terraform.d/plugin-cache"

      # kubectl configurations
      set -l KUBECONFIGS ${homeDirectory}/.kube/config
      for name in ${homeDirectory}/.kube/kubeconfig-*.yaml;
          set -a KUBECONFIGS $name
      end
      set -Ux KUBECONFIG (string join ':' $KUBECONFIGS)
    '';
  };

  home.activation.defaultShell =
    home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      $VERBOSE_ECHO "Setting fish as default shell"

      WANTED=/run/current-system/sw/bin/fish

      if [[ $WANTED != $(dscl . -read ~/ UserShell | sed 's/UserShell: //') ]]; then
        $DRY_RUN_CMD chsh -s $WANTED
      fi
    '';

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
      excludesfile = ${homeDirectory}/.gitignore_global
    '';

    ".gitignore_global".text = ''
    *~
    *.swp
    *.swo
    .DS_Store
    '';

    ".editorconfig".text = ''
    # unifying the coding style for different editors and IDEs => editorconfig.org

    ; indicate this is the root of the project
    root = true

    [*]
    charset = utf-8

    end_of_line = LF
    insert_final_newline = true
    trim_trailing_whitespace = true

    indent_style = space
    indent_size = 2
    tab_width = 4

    [Makefile,makefile]
    indent_style = tab

    [*.md]
    trim_trailing_whitespace = false

    [*.go]
    indent_style = tab

    [*.rs]
    indent_style = space
    indent_size = 4
    '';
  };

  # Spacemacs
  home.file.".spacemacs.env".text = ''
    DISPLAY=Mac
    HOME=${homeDirectory}
    LANG=en_GB.UTF-8
    LOGNAME=daniel
    PATH=${homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin:${homeDirectory}/.goenv/shims:${homeDirectory}/.rbenv/shims:${homeDirectory}/.pyenv/shims:${homeDirectory}/.nodenv/shims:${homeDirectory}/.cargo/bin:${homeDirectory}/go/bin:${homeDirectory}/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
    PWD=${homeDirectory}
    SHELL=/bin/bash
    USER=daniel
    '';

  home.activation.cloneSpacemacs =
    home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      $VERBOSE_ECHO "Cloning Spacemacs"

      DOTEMACSD=${homeDirectory}/.emacs.d

      if [[ ! -d $DOTEMACSD ]]; then
        $DRY_RUN_CMD git clone https://github.com/syl20bnr/spacemacs.git $DOTEMACSD
      fi

      $DRY_RUN_CMD cd $DOTEMACSD
      $DRY_RUN_CMD git pull origin develop
    '';
}
