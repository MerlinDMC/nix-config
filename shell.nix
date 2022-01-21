{ pkgs ? import <nixpkgs> {} }:
let
  systemSetup = ''
    set -e
    echo >&2 "Installing Nix-Darwin..."
    # setup /run directory for darwin system installations
    if ! grep -q '^run\b' /etc/synthetic.conf 2>/dev/null; then
      echo "setting up /etc/synthetic.conf..."
      echo -e "run\tprivate/var/run" | sudo tee -a /etc/synthetic.conf >/dev/null
      /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -B 2>/dev/null || true
      /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t 2>/dev/null || true
    fi
    if ! test -L /run; then
        echo "setting up /run..."
        sudo ln -sfn private/var/run /run
    fi
  '';

  darwinBuildScript = ''
    ${pkgs.nixFlakes}/bin/nix build ".#darwinConfigurations.bootstrap-arm.system" --experimental-features "flakes nix-command" --show-trace
  '';

  homebrewInstallScript = ''
    ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  '';

  darwinInstall = pkgs.writeShellScriptBin "darwinInstall" ''
    ${systemSetup}
    ${homebrewInstallScript}
    ${darwinBuildScript}
    sudo ./result/activate
  '';

  homebrewInstall = pkgs.writeShellScriptBin "homebrewInstall" ''
    ${homebrewInstallScript}
  '';

in pkgs.mkShell {
  buildInputs = [ pkgs.nixFlakes darwinInstall homebrewInstall ];
}
