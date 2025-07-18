{ ... }: {
  home.sessionVariables = {
    # Hint Firefox to use Wayland features.
    MOZ_ENABLE_WAYLAND = 1;
  };

  programs.firefox = {
    enable = true;

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

}
