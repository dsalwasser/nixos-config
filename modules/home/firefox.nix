{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.firefox;
in {
  options.components.home.firefox = {
    enable = lib.mkEnableOption "Whether to enable Firefox.";
    makeDefaultBrowser = lib.mkEnableOption "Make Firefox the default browser.";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      # Hint Firefox to use Wayland features.
      MOZ_ENABLE_WAYLAND = 1;

      # Improves touchscreen support and enables additional touchpad gestures. It
      # also enables smooth scrolling as opposed to the stepped scrolling that
      # Firefox has by default.
      MOZ_USE_XINPUT2 = 1;
    };

    xdg.mimeApps.defaultApplications = lib.mkIf cfg.makeDefault {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };

    programs.firefox = {
      enable = true;

      languagePacks = ["de" "en"];

      nativeMessagingHosts = [pkgs.kdePackages.plasma-browser-integration];

      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisplayBookmarksToolbar = "newtab";

        ExtensionSettings = {
          # Block all addons except the ones specified below
          "*".installation_mode = "blocked";

          # uBlock Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          # Firefox Multi-Account Containers
          "@testpilot-containers" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
            installation_mode = "force_installed";
          };

          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };

          # KDE Plasma Integration
          "{plasma-browser-integration@kde.org}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        Preferences = {
          # Make Firefox use the KDE file picker.
          "widget.use-xdg-desktop-portal.file-picker" = 1;

          # The following preferences were obtained from Betterfox (v146):
          # https://github.com/yokoffing/BetterFox.

          # Increase Firefox's browsing speed

          ## Improve GFX
          "gfx.content.skia-font-cache-size" = 32;
          "gfx.webrender.layer-compositor" = true;
          "gfx.canvas.accelerated.cache-items" = 32768;
          "gfx.canvas.accelerated.cache-size" = 4096;
          "webgl.max-size" = 16384;

          ## Disable disk cache
          "browser.cache.disk.enable" = false;

          ## Optimize memory cache
          "browser.cache.memory.capacity" = 131072;
          "browser.cache.memory.max_entry_size" = 20480;
          "browser.sessionhistory.max_total_viewers" = 4;
          "browser.sessionstore.max_tabs_undo" = 10;

          ## Optimize media cache
          "media.memory_cache_max_size" = 262144;
          "media.memory_caches_combined_limit_kb" = 1048576;
          "media.cache_readahead_limit" = 600;
          "media.cache_resume_threshold" = 300;

          ## Optimize image cache
          "image.cache.size" = 10485760;
          "image.mem.decode_bytes_at_a_time" = 65536;

          ## Optimize networking settings
          "network.http.max-connections" = 1800;
          "network.http.max-persistent-connections-per-server" = 10;
          "network.http.max-urgent-start-excessive-connections-per-host" = 5;
          "network.http.request.max-start-delay" = 5;
          "network.http.pacing.requests.enabled" = false;
          "network.dnsCacheEntries" = 10000;
          "network.dnsCacheExpiration" = 3600;
          "network.ssl_tokens_cache_capacity" = 10240;

          ## Disable speculative loading
          "network.http.speculative-parallel-limit" = 0;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.places.speculativeConnect.enabled" = false;
          "network.prefetch-next" = false;

          # Improve user data protection without causing site breakage

          ## Improve tracking protection
          "browser.contentblocking.category" = "strict";
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.uitour.enabled" = false;
          "privacy.globalprivacycontrol.enabled" = true;

          ## Disable OCSP
          "security.OCSP.enabled" = 0;
          "privacy.antitracking.isolateContentScriptResources" = true;
          "security.csp.reporting.enabled" = false;

          ## Display warning on the padlock for insecure pages and improve TLS
          ## security
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "security.tls.enable_0rtt_data" = false;

          ## Set media cache in Private Browsing to in-memory
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "browser.sessionstore.interval" = 60000;

          ## Improve sanitizing
          "privacy.history.custom" = true;
          "browser.privatebrowsing.resetPBM.enabled" = true;

          ## Improve URL bar
          "browser.urlbar.trimHttps" = true;
          "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.formfill.enable" = false;
          "network.IDN_show_punycode" = true;

          ## Enable HTTPS-only mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_error_page_user_suggestions" = true;

          ## Improve password handling
          "signon.formlessCapture.enabled" = false;
          "signon.privateBrowsingCapture.enabled" = false;
          "network.auth.subresource-http-auth-allow" = 1;
          "editor.truncate_user_pastes" = false;

          ## Limit allowed extension directories
          "extensions.enabledScopes" = 5;

          ## Reduce the amount of cross-origin information send (2=scheme+host+port)
          "network.http.referer.XOriginTrimmingPolicy" = 2;

          ## Enable containers
          "privacy.userContext.ui.enabled" = true;

          ## Disable PDF scripting
          "pdfjs.enableScripting" = false;

          ## Disable Googles Safe Browsing
          "browser.safebrowsing.downloads.remote.enabled" = false;

          ## Improve Mozilla security
          "permissions.default.desktop-notification" = 2;
          "permissions.default.geo" = 2;
          "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
          "browser.search.update" = false;
          "permissions.manager.defaultsUrl" = "";
          "extensions.getAddons.cache.enabled" = false;

          ## Disable telemetry
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "datareporting.usage.uploadEnabled" = false;

          ## Disable experiments
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";

          ## Disable crash reports
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;

          # Improve the browsing experience

          ## Improve Mozilla UI
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.preferences.moreFromMozilla" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.aboutwelcome.enabled" = false;
          "browser.profiles.enabled" = true;

          ## Theme adjustments
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.compactmode.show" = true;
          "browser.privateWindowSeparation.enabled" = false;

          ## Disable AI integration
          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.ml.chat.menu" = false;
          "browser.tabs.groups.smart.enabled" = false;
          "browser.ml.linkPreview.enabled" = false;

          ## Disable full-screen notice
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";
          "full-screen-api.warning.timeout" = 0;

          ## Disable URL bar trending search suggestions
          "browser.urlbar.trending.featureGate" = false;

          ## Improve new tab page layout content
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;

          ## Disable adding downloads to the system's "recent documents" list
          "browser.download.manager.addToRecentDocs" = false;

          ## Open PDFs inline
          "browser.download.open_pdf_attachments_inline" = true;

          ## Improve tab behavior
          "browser.bookmarks.openInTabClosesMenu" = false;
          "browser.menu.showViewImageInfo" = true;
          "findbar.highlightAll" = true;
          "layout.word_select.eat_space_to_next_word" = false;
        };
      };
    };
  };
}
