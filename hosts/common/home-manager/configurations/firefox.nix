{ pkgs, ... }: {
  home.sessionVariables = {
    # Hint Firefox to use Wayland features.
    MOZ_ENABLE_WAYLAND = 1;

    # Improves touchscreen support and enables additional touchpad gestures. It
    # also enables smooth scrolling as opposed to the stepped scrolling that
    # Firefox has by default.
    MOZ_USE_XINPUT2 = 1;
  };

  programs.firefox = {
    enable = true;

    languagePacks = [ "de" "en" ];

    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];

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
