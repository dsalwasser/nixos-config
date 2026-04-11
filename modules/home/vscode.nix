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
      mutableExtensionsDir = false;

      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        enableMcpIntegration = false;

        extensions = with pkgs.vscode-extensions; [
          # German Language Pack
          ms-ceintl.vscode-language-pack-de

          # Enable better error highlighting.
          usernamehw.errorlens

          # Spell checker
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german

          # Language support for Bash, Latex, Nix, TOML
          mads-hartmann.bash-ide-vscode
          james-yu.latex-workshop
          jnoortheen.nix-ide
          tamasfe.even-better-toml

          # Language support for C/C++ and CMake
          llvm-vs-code-extensions.vscode-clangd
          ms-vscode.cmake-tools

          # Language support for Python
          ms-python.python
          charliermarsh.ruff

          # Language support for web development
          esbenp.prettier-vscode

          # GitHub Copilot
          github.copilot-chat
        ];

        keybindings = [
          # Shortcut to open a new terminal in the workspace root directory
          {
            key = "ctrl+t";
            command = "workbench.action.terminal.newWithCwd";
            args.cwd = "\${workspaceFolder}";
          }
          # Shortcut to open a new terminal inside the current directory
          {
            key = "ctrl+shift+t";
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
          "editor.formatOnSave" = true;

          "extensions.autoUpdate" = false;
          "extensions.ignoreRecommendations" = true;

          "explorer.autoReveal" = false;
          "update.showReleaseNotes" = false;
          "workbench.startupEditor" = "none";

          "telemetry.telemetryLevel" = "off";
          "chat.disableAIFeatures" = false;

          "editor.inlineSuggest.enabled" = false;
          "github.copilot.enable" = {
            "*" = false;
            "plaintext" = false;
            "markdown" = false;
            "scminput" = false;
          };

          "cSpell.language" = "en,de-de";
          "cSpell.enabledFileTypes" = {
            "*" = false;
            "latex" = true;
            "markdown" = true;
            "plaintext" = true;
          };

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

          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };
        };
      };
    };

    # Add a context menu entry for Dolphin to open VS Code.
    home.file.".local/share/kio/servicemenus/open-with-vscode.desktop".text = ''
      [Desktop Entry]
      Name=Open in VSCode
      Name[de]=In VSCode öffnen
      Type=Service
      Actions=openInVSCode
      MimeType=all/all
      X-KDE-Priority=TopLevel

      [Desktop Action openInVSCode]
      Name=Open in VSCode
      Name[de]=In VSCode öffnen
      Icon=vscode
      Exec=code %f
    '';
  };
}
