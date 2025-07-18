{ inputs, pkgs, ... }: {
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (final: prev: {
        additions = {
          fonts = import ./packages/apple-fonts.nix final;
          spotify-adblock = import ./packages/spotify-adblock.nix final;
          zjstatus = inputs.zjstatus.packages.${prev.system}.default;
        };

        discord = prev.discord.override {
          withOpenASAR = true;
          withVencord = true;
        };

        firefox = prev.firefox.override {
          nativeMessagingHosts = [
            prev.kdePackages.plasma-browser-integration
          ];
        };

        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-full;
        };
      })
    ];
  };

  imports = [
    ./modules/alacritty.nix
    ./modules/distrobox.nix
    ./modules/firefox.nix
    ./modules/helix.nix
    ./modules/plasma.nix
    ./modules/spicetify.nix
    ./modules/virtualization.nix
    ./modules/vscode.nix
    ./modules/zellij.nix
  ];

  home = {
    username = "sali";
    homeDirectory = "/home/sali";

    file = {
      # Disable the Baloo file indexer.
      "/.config/baloofilerc".source = ./assets/baloofilerc;

      # Add a context menu entry for Dolphin to open VS Code.
      ".local/share/kio/servicemenus/open-with-vscode.desktop".source = ./assets/open-with-vscode.desktop;
    };

    sessionVariables = {
      # Use Helix as the default editor.
      EDITOR = "hx";

      # Enable Ozone Wayland support in Chromium and Electron based applications.
      NIXOS_OZONE_WL = 1;

      # Point Ipe to the the directory containing pdflatex and xelatex
      IPELATEXPATH = "${pkgs.tex}/bin/";
    };
  };

  # Enable fontconfig configuration. This will, for example, allow fontconfig
  # to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Command-line Tools
    bartib
    bottom
    neofetch
    nix-your-shell
    nvtopPackages.full
    restic

    # Language servers for various languages
    bash-language-server
    cmake-language-server
    clang-tools
    dockerfile-language-server-nodejs
    marksman
    nil
    nixpkgs-fmt
    texlab

    # Desktop applications
    bitwarden
    discord
    easyeffects
    google-chrome
    inkscape
    ipe
    mpv
    obsidian
    pympress
    thunderbird
    tor-browser

    # Other desktop stuff
    kdePackages.sddm-kcm
    lmodern
    tex
    wayland-utils
    wl-clipboard
    xdg-utils
  ] ++ (with pkgs.additions; [
    fonts.sf-mono
    fonts.sf-pro
    zjstatus
  ]);

  programs = {
    eza = {
      enable = true;
      enableFishIntegration = true;

      extraOptions = [
        "--long"
        "--all"
        "--group-directories-first"
        "--header"
      ];
      git = true;
    };

    lazygit = {
      enable = true;

      settings = {
        git.autoFetch = false;
      };
    };

    oh-my-posh = {
      enable = true;
      enableFishIntegration = true;

      useTheme = "ys";
    };

    zellij = {
      enable = true;
      enableFishIntegration = false;

      layout = ./assets/layout.kdl;
      settings = {
        pane_frames = false;
        ui.pane_frames.hide_session_name = true;
        keybinds.unbind = "Ctrl b";
      };
    };
  };

  programs.fish = {
    enable = true;

    # Disable greeting
    interactiveShellInit = ''
      set fish_greeting
      ${pkgs.nix-your-shell}/bin/nix-your-shell fish | source
      set -x SHELL (which fish)
    '';
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;

    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  programs.git = {
    enable = true;

    extraConfig.init.defaultBranch = "main";

    userEmail = "daniel.salwasser@outlook.com";
    userName = "Daniel Salwasser";

    signing = {
      key = "6CD20B2D0655BDF6";
      signByDefault = true;
    };
  };

  programs.nix-index.enable = true;

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs.
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
