{ config, pkgs, user, lib, ... }:
let
  baseDir = if pkgs.stdenv.isDarwin then "/Users" else "/home";
in
{
  home.stateVersion = "26.05";
  home.username = user;
  home.homeDirectory = "${baseDir}/${user}";
  home.packages = [
    pkgs.gemini-cli
    pkgs.tailscale
    pkgs.gh
    pkgs.zed-editor
    pkgs.bitwarden-desktop
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "${baseDir}/${user}/.bitwarden-ssh-agent.sock";
  };

  programs.git = {
    enable = true;
    settings.gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    settings.user = {
      name = "erechorse";
      email = "erechorse@gmail.com";
    };
    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzSOcFyPcFRmGtFTJEX7KRvVg0WFM67NpcYmSGXv7Kj";
      signByDefault = true;
    };
  };

  home.file.".ssh/allowed_signers".text = "erechorse@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzSOcFyPcFRmGtFTJEX7KRvVg0WFM67NpcYmSGXv7Kj";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
    '';
  };
}
