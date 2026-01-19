{ config, pkgs, user, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = user;

  programs.zsh.enable = true;

  users.users.${user} = {
    name = user;
    home = "/home/${user}";
    shell = pkgs.zsh;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
