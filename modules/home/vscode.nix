{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.vscode;
in {
  options.components.home.vscode = {
    enable = lib.mkEnableOption "Whether to enable VSCode.";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = with pkgs.vscode-extensions; [
          # German Language Pack
          ms-ceintl.vscode-language-pack-de

          # Enable better error highlighting.
          usernamehw.errorlens

          # Spell checker
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german

          # Formatter
          esbenp.prettier-vscode

          # Support for TOML, Markdown and LaTex
          tamasfe.even-better-toml
          yzhang.markdown-all-in-one
          james-yu.latex-workshop

          # Language support for Nix, Bash, R, and Java
          jnoortheen.nix-ide
          mads-hartmann.bash-ide-vscode
          reditorsupport.r
          reditorsupport.r-syntax
          vscjava.vscode-java-pack

          # Language support for C/C++ and CMake
          llvm-vs-code-extensions.vscode-clangd
          ms-vscode.cmake-tools

          # Language support for Python
          ms-python.python
          charliermarsh.ruff
          njpwerner.autodocstring

          # Language support for Java
          redhat.java
          vscjava.vscode-java-debug
          vscjava.vscode-java-test
          vscjava.vscode-maven
          vscjava.vscode-gradle
          vscjava.vscode-java-dependency

          # GitHub Copilot
          github.copilot-chat
        ];

        keybindings = [
          # Shortcut to open a new terminal inside the current directory
          {
            key = "ctrl+t";
            command = "workbench.action.terminal.newWithCwd";
            args.cwd = "\${fileDirname}";
          }
          # Shortcut to trigger inline suggestions
          {
            key = "alt+\\";
            command = "editor.action.inlineSuggest.trigger";
          }
        ];

        userSettings = {
          "editor.fontFamily" = "SF Mono";
          "editor.fontSize" = 13;
          "window.zoomLevel" = 0.8;

          "editor.formatOnSave" = true;

          "extensions.ignoreRecommendations" = true;
          "explorer.autoReveal" = false;
          "update.showReleaseNotes" = false;
          "workbench.startupEditor" = "none";

          "telemetry.telemetryLevel" = "off";
          "chat.disableAIFeatures" = false;

          "cSpell.language" = "en,de-de";

          "latex-workshop.formatting.latex" = "latexindent";
          "latex-workshop.formatting.latexindent.args" = [
            "-c"
            "%DIR%/"
            "%TMPFILE%"
            "-l=%WORKSPACE_FOLDER%/localSettings.yaml"
            "-m"
          ];

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = ["alejandra"];
              };
            };
          };

          "cmake.automaticReconfigure" = false;
          "cmake.configureOnEdit" = false;
          "cmake.configureOnOpen" = false;

          "[cpp]" = {
            "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          };

          "[python]" = {
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.fixAll" = "explicit";
              "source.organizeImports" = "explicit";
            };
            "editor.defaultFormatter" = "charliermarsh.ruff";
          };

          "java.jdt.ls.java.home" = "${pkgs.jdk21}";
          "java.imports.gradle.wrapper.checksums" = [
            {
              "sha256" = "7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172";
              "allowed" = true;
            }
          ];

          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };

          "editor.inlineSuggest.enabled" = false;
          "github.copilot.enable" = {
            "*" = false;
            "plaintext" = false;
            "markdown" = false;
            "scminput" = false;
          };
        };
      };
    };

    # Add a context menu entry for Dolphin to open VS Code.
    home.file.".local/share/kio/servicemenus/open-with-vscode.desktop".text = ''
      [Desktop Entry]
      Name=Open in VSCodium
      Name[de]=In VSCodium öffnen
      Type=Service
      Actions=openInVSCodium
      MimeType=all/all
      X-KDE-Priority=TopLevel

      [Desktop Action openInVSCodium]
      Name=Open in VSCodium
      Name[de]=In VSCodium öffnen
      Icon=vscodium
      Exec=codium %f
    '';
  };
}
