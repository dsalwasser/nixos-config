# This is the home-manager configuration file and is used to configure the home
# environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, pkgs, ... }: {
  imports = [
    ./modules/zellij.nix
  ];

  nixpkgs = {
    overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
          config.allowUnfree = true;

          overlays = [
            (final: prev: {
              firefox = prev.firefox.override {
                nativeMessagingHosts = [
                  prev.kdePackages.plasma-browser-integration
                ];
              };

              discord = prev.discord.override {
                withOpenASAR = true;
                withVencord = true;
              };

              tex = pkgs.texlive.combine {
                inherit (pkgs.texlive) scheme-full;
              };
            })
          ];
        };

        additions = {
          fonts = import ./packages/apple-fonts.nix final.pkgs;
          zjstatus = inputs.zjstatus.packages.${prev.system}.default;
        };
      })
    ];

    config = {
      # Allow unfree packages.
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942.
      allowUnfreePredicate = (_: true);
    };
  };

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

      # Hint Firefox to use Wayland features.
      MOZ_ENABLE_WAYLAND = 1;
    };
  };

  # Enable fontconfig configuration. This will, for example, allow fontconfig
  # to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  home.packages = with pkgs.unstable; [
    # Command-line Tools
    bartib
    neofetch
    nvtopPackages.full
    restic
    unzip

    # Language servers for various languages
    bash-language-server
    cmake-language-server
    clang-tools_18
    dockerfile-language-server-nodejs
    marksman
    nil
    nixpkgs-fmt
    texlab

    # Desktop applications
    bitwarden
    discord
    inkscape
    obsidian
    pympress
    thunderbird
    tor-browser

    # Other desktop stuff
    lmodern
    tex
    wayland-utils
    wl-clipboard
    xdg-utils
  ] ++ (with pkgs.additions; [
    fonts.sf-mono
    fonts.sf-pro
    zjstatus
  ]) ++ (with pkgs; [
    # Fetch packages from stable repository to avoid incompatible Qt library.
    kdePackages.sddm-kcm
    ipe
  ]);

  programs.plasma = {
    enable = true;

    workspace.lookAndFeel = "org.kde.breezedark.desktop";

    fonts = {
      general = {
        family = "SF Pro Text";
        pointSize = 11;
      };

      fixedWidth = {
        family = "SF Mono";
        pointSize = 11;
      };

      small = {
        family = "SF Pro Text";
        pointSize = 8;
      };

      toolbar = {
        family = "SF Pro Text";
        pointSize = 10;
      };

      menu = {
        family = "SF Pro Text";
        pointSize = 10;
      };

      windowTitle = {
        family = "SF Pro Text";
        pointSize = 10;
      };
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox;

    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisplayBookmarksToolbar = "newtab";

      Preferences = {
        # Make Firefox use the KDE file picker.
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;

    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-de
      ms-vscode-remote.remote-ssh

      usernamehw.errorlens

      valentjn.vscode-ltex

      reditorsupport.r

      jnoortheen.nix-ide
      james-yu.latex-workshop
      mads-hartmann.bash-ide-vscode

      # Python extensions
      ms-python.python
      charliermarsh.ruff
      njpwerner.autodocstring
      tamasfe.even-better-toml

      # The C/C++ extension pack consists of the following extensions.
      ms-vscode.cmake-tools
      twxs.cmake
      llvm-vs-code-extensions.vscode-clangd
    ];

    keybindings = [
      {
        key = "ctrl+t";
        command = "workbench.action.terminal.newWithCwd";
        args.cwd = "\${fileDirname}";
      }
    ];

    userSettings = {
      "editor.fontFamily" = "SF Mono";
      "editor.fontSize" = 13;
      "editor.formatOnSave" = false;
      "extensions.ignoreRecommendations" = true;
      "explorer.autoReveal" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
      "telemetry.telemetryLevel" = "off";
      "window.zoomLevel" = 0.8;
      "workbench.startupEditor" = "none";
      "latex-workshop.latexindent.args" = [
        "-c"
        "%DIR%/"
        "%TMPFILE%"
        "-l=%WORKSPACE_FOLDER%/localSettings.yaml"
        "-m"
      ];
      "[cpp]" = {
        "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      };
      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };
    };
  };

  programs = {
    bottom = {
      enable = true;
      package = pkgs.unstable.bottom;
    };
    eza = {
      enable = true;
      package = pkgs.unstable.eza;

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
      package = pkgs.unstable.lazygit;

      settings = {
        git.autoFetch = false;
      };
    };
    oh-my-posh = {
      enable = true;
      package = pkgs.unstable.oh-my-posh;

      enableFishIntegration = true;
      useTheme = "ys";
    };
    zellij = {
      enable = true;
      package = pkgs.unstable.zellij;

      layout = ./assets/layout.kdl;
      settings = {
        pane_frames = false;
        ui.pane_frames.hide_session_name = true;
        keybinds.unbind = "Ctrl b";
      };
    };
    zoxide = {
      enable = true;
      package = pkgs.unstable.zoxide;
      enableFishIntegration = true;
    };
  };

  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;

    languages.language = [
      {
        name = "nix";
        formatter.command = "nixpkgs-fmt";
      }
      {
        name = "cpp";
        indent = { tab-width = 2; unit = "  "; };
      }
    ];

    settings = {
      editor = {
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        lsp.display-messages = true;
      };

      keys.normal = {
        C-y = "goto_prev_function";
        C-x = "goto_next_function";

        A-y = "goto_prev_class";
        A-x = "goto_next_class";

        A-w = "goto_definition";
      };
    };
  };

  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;

    settings = {
      font = {
        normal.family = "SF Mono";
        size = 11;
      };

      keyboard.bindings = [
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
        {
          key = "PageUp";
          action = "ScrollPageUp";
        }
        {
          key = "PageDown";
          action = "ScrollPageDown";
        }
      ];

      window.dynamic_padding = true;
    };
  };

  # Enable fish shell.
  programs.fish = {
    enable = true;

    # Disable greeting
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  # Enable GPG and GPG-agent.
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;

    enableFishIntegration = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # Enable and set up Git.
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;

    delta = {
      enable = true;
      package = pkgs.unstable.delta;
    };

    # Set the default branch name to 'main'.
    extraConfig.init.defaultBranch = "main";

    userEmail = "danielsalwater@gmail.com";
    userName = "Daniel Salwasser";

    signing = {
      key = "8C4BD12090EB82AF";
      signByDefault = true;
    };
  };

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs.
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
