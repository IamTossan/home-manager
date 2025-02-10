{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tossan";
  home.homeDirectory = "/home/tossan";

  # nixGL (for terminal emulator)
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

  xdg.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

   # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.nerd-fonts.hack
    pkgs.tmux
    pkgs.neovim

    pkgs.bottom
    pkgs.lazygit
    pkgs.tree
    pkgs.ripgrep
    pkgs.cmatrix
    pkgs.neofetch
    pkgs.tldr
    
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/tossan/Documents/coding/nix/nvim";
    };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tossan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    TERM = "xterm-256color";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 10;
        normal = {
          family = "Hack Nerd Font Mono";
          style = "regular";
        };
      };
      window = {
        decorations = "None";
        opacity = 0.9;
        padding = {
          x = 8;
          y = 8;
        };
      };
    };
    package = config.lib.nixGL.wrap pkgs.alacritty;
  };
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      background-opacity = 0.8;
      term = "xterm-256color";
      window-decoration = "none";
      font-size = 10;
      gtk-tabs-location = "hidden";
      window-padding-x = 5;
      window-padding-y = 5;

      keybind = [
        "ctrl+a>a=toggle_window_decorations"
        "ctrl+a>tab=toggle_tab_overview"
      ];
    };
    package = config.lib.nixGL.wrap pkgs.ghostty;
  };

  programs.tmux = {
    enable = true; 
    terminal = "tmux-256color";
    historyLimit = 100000;
    extraConfig = ''
      set -g status-position top
      set -g mouse on
      set-window-option -g mode-keys vi
    '';
    plugins = with pkgs; [
      # tmuxPlugins.cpu
      # {
      #   plugin = tmuxPlugins.catppuccin;
      #   extraConfig = '' 
      #     set -g @catppuccin_flavour 'frappe'
      #     set -g @catppuccin_window_status_style "rounded"
      #     set -g status-left ""
      #     set -g status-right "#{E:@catppuccin_status_application}"
      #     set -agF status-right "#{E:@catppuccin_status_cpu}"
      #     set -agF status-right "#{E:@catppuccin_status_load}"
      #     set -ag status-right "#{E:@catppuccin_status_uptime}"
      #
      #     set -g @catppuccin_window_tabs_enabled on
      #     set -g @catppuccin_date_time "%Y-%m-%d %H:%M:%S"
      #   '';
      # }
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-powerline true
          set -g @dracula-plugins "cpu-usage ram-usage network-bandwidth time"

          set -g @dracula-time-format "%Y-%m-%d %H:%M:%S"

          set -g @dracula-cpu-usage-colors "pink dark_gray"
          set -g @dracula-ram-usage-colors "green dark_gray"
          set -g @dracula-network-bandwidth-colors "orange dark_gray"
          set -g @dracula-time-colors "light_purple dark_gray"
          
          set -g @dracula-network-bandwidth enp7s0
          set -g @dracula-network-bandwidth-interval 0
          set -g @dracula-network-bandwidth-show-interface true
          set -g @dracula-show-powerline true
        '';
      }
    ];
  };

  targets.genericLinux.enable = true;
  home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = "/usr/bin/sudo /usr/bin/chmod -R 777 $HOME/.nix-profile/share/applications && /usr/bin/update-desktop-database $HOME/.nix-profile/share/applications";
    };
    setDefaultTerminal = ''
      /usr/bin/gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'
    '';
  };

  fonts.fontconfig.enable = true;
}
