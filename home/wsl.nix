{ pkgs, config, lib, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh.initExtra = ''
    keep_current_path() {
      printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
    precmd_functions+=(keep_current_path)
  '';
}
