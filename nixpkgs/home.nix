{ config, pkgs, specialArgs, lib, ... }:
with pkgs;
let
  # Discord
  discordUpdated = pkgs.discord.override rec {
    version = "0.0.21";
    src = builtins.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "18rmw979vg8lxxvagji6sim2s5yyfq91lfabsz1wzbniqfr98ci8";
    };
  };
in
{
  # User Packages
  home.packages = with pkgs; [

    # Browser
    discordUpdated
    chromium
    evince

    # Terminal
    sl lolcat
    thefuck oh-my-zsh zsh-powerlevel10k zplug
    tree
    tig
    ascii

    # Tools
    pciutils
    xclip
    flameshot
    direnv

    # Yubikey
    yubikey-manager-qt

    # Code
    universal-ctags
    mono
    gdb

  ];

  programs = {

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    command-not-found.enable = true;

    # Git Configuration
    git = {
      enable = true;
      userName = "Baptiste Arnold";
      userEmail = "baptiste.arnold" + "@" + "epita.fr";
      aliases = {
        lg = "log --all --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
      ignores = [ "*~" "*.swp" ".o" ".d" "format_marker"];
      lfs.enable = true;
    };

    # ZSH Configuration
    zsh = {
      enable = true;
      shellAliases = {
        home = "vim ~/.config/nixpkgs/home.nix";
        update = "home-manager switch";
        ntm = "poweroff";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };
      initExtra = builtins.readFile ./zshrc;
    };

    # Vim Configuration
    vim = {
      enable = true;
      settings = {
        relativenumber = true;
        number = true;
        expandtab = true;
        ignorecase = true;
        shiftwidth = 4;
        tabstop = 8;
      };
      extraConfig = builtins.readFile vim/vimrc;
    };

    # Rofi Configuration
    rofi = {
      enable = true;
      theme = "~/.config/nixpkgs/rofi/lb.rasi";
    };
  };

  services = {

    # Picom Configuration
    picom = {
      enable = true;
      blur = true;
      shadow = true;
    };

    # GPG Configuration
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "curses";
    };
  };


  # i3
  xsession.windowManager.i3 = import ./i3.nix {inherit pkgs lib;};

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "akilson";
  home.homeDirectory = "/home/akilson";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
