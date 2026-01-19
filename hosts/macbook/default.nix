{ config, pkgs, user, ... }:

{
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = 6;
}
