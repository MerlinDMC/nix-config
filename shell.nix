{ pkgs ? import <nixpkgs> {} }:
let
  getSystemUUID = ''
    SYSTEM_UUID=$(/usr/sbin/system_profiler SPHardwareDataType | awk -F': ' '/Hardware UUID/ { print tolower($2) }')
  '';

  systemRebuild = pkgs.writeShellScriptBin "system-rebuild" ''
    ${getSystemUUID}
    ${pkgs.nixFlakes}/bin/nix run nix-darwin -- switch --flake ".#$SYSTEM_UUID" || \
    ${pkgs.nixFlakes}/bin/nix run nix-darwin -- switch --flake .
  '';

  systemUpdate = pkgs.writeShellScriptBin "system-update" ''
    ${pkgs.nixFlakes}/bin/nix flake update

    (cd $HOME/.emacs.d
      ${pkgs.git}/bin/git pull --autostash --rebase
    )
  '';

in pkgs.mkShell {
  buildInputs = [
    pkgs.nixFlakes
    systemUpdate
    systemRebuild
  ];
}
