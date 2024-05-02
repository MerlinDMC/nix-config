#!/bin/bash

{ # Prevent execution if this script was only partially downloaded

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `bootstrap.sh` has finished
while true; do sudo -n true; sleep 30; kill -0 "$$" || exit; done 2>/dev/null &

log() {
  echo >&2 $@
}

has_util() {
  command -v "$1" > /dev/null 2>&1
}

has_folder() {
  test -d "$1" > /dev/null 2>&1
}

log "=> Checking for Nix"

has_util "nix" || (
  log "~> Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | /bin/bash -s -- install --no-confirm

  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
)

log "=> Checking for Homebrew"

HOMEBREW_BIN_DIR="/usr/local/bin"

if [[ `uname -m` == 'arm64' ]]; then
  HOMEBREW_BIN_DIR="/opt/homebrew/bin"
fi

export PATH=$PATH:$HOMEBREW_BIN_DIR

has_util "brew" || (
  log "~> Installing Homebrew..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash -s
)

log "=> Checking for nix-config repository updates"

has_folder ~/.config/nix-config || (
  log "~> Cloning nix-config..."
  /usr/bin/git clone https://github.com/MerlinDMC/nix-config.git ~/.config/nix-config
)

( cd ~/.config/nix-config;
  log "=> Instance bootstrap"

  log "~> Updating nix-config..."
  /usr/bin/git pull --rebase --autostash

  log "~> Running nix-darwin switch bootstrap..."
  nix run nix-darwin -- switch --flake '.#bootstrap'

  log "~> Rebuilding system..."
  nix-shell --run system-rebuild
)

} # End of wrapping
