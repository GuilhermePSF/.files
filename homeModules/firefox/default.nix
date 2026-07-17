{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.firefoxModule.enable = lib.mkEnableOption "Enable Firefox Module";

  config = lib.mkIf config.firefoxModule.enable {

    stylix.targets.firefox.profileNames = [ "default" ];

    programs.firefox = {
      enable = true;
      package = pkgs.firefox;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFirefoxAccounts = false;
        DisableFormHistory = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        HttpsOnlyMode = "force_enabled";
        SearchSuggestEnabled = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = false;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          };
          "sponsorBlocker@ajay.app" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          };
          "{3c078156-979c-498b-8990-7f0480e1500f}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
          };
          "@testpilot-containers" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          };
        };
      };

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        settings = {
          "browser.startup.homepage" = "about:blank";
          "browser.startup.page" = 3;
          "browser.newtabpage.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.donotrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "dom.security.https_only_mode" = true;
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "browser.tabs.inTitlebar" = 0;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;
          "ui.systemUsesDarkTheme" = 1;
          "browser.theme.dark-private-windows" = true;
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.disableResetPrompt" = true;
          "browser.aboutwelcome.enabled" = false;
          "extensions.pocket.enabled" = false;
          "identity.fxaccounts.enabled" = true;
        };

        userChrome = ''
          :root {
            --tn-bg:        #1a1b26;
            --tn-bg-dark:   #16161e;
            --tn-bg-hl:     #292e42;
            --tn-border:    #29293d;
            --tn-fg:        #c0caf5;
            --tn-fg-dim:    #565f89;
            --tn-blue:      #7aa2f7;
            --tn-cyan:      #7dcfff;
            --tn-purple:    #bb9af7;
            --tn-green:     #9ece6a;
            --tn-red:       #f7768e;
            --tn-yellow:    #e0af68;
          }

          #main-window, #navigator-toolbox {
            background-color: var(--tn-bg-dark) !important;
            color: var(--tn-fg) !important;
          }

          #nav-bar {
            background-color: var(--tn-bg) !important;
            border-bottom: 1px solid var(--tn-border) !important;
          }

          #urlbar-background {
            background-color: var(--tn-bg-hl) !important;
            border: 1px solid var(--tn-border) !important;
            border-radius: 6px !important;
          }
          #urlbar:focus-within > #urlbar-background {
            border-color: var(--tn-blue) !important;
            box-shadow: 0 0 0 1px var(--tn-blue) !important;
          }
          #urlbar-input { color: var(--tn-fg) !important; }

          #TabsToolbar { visibility: collapse !important; }

          #sidebar-box {
            background-color: var(--tn-bg-dark) !important;
            border-right: 1px solid var(--tn-border) !important;
            min-width: 200px !important;
            max-width: 300px !important;
          }
          #sidebar-header { display: none !important; }

          #PersonalToolbar {
            background-color: var(--tn-bg) !important;
            border-bottom: 1px solid var(--tn-border) !important;
          }
          .bookmark-item > .toolbarbutton-text { color: var(--tn-fg) !important; }

          menupopup, panel {
            background-color: var(--tn-bg-hl) !important;
            border: 1px solid var(--tn-border) !important;
            border-radius: 6px !important;
          }
          menuitem, menu {
            color: var(--tn-fg) !important;
            border-radius: 4px !important;
          }
          menuitem:hover { background-color: var(--tn-bg-dark) !important; }

          toolbarbutton:hover {
            background-color: var(--tn-bg-hl) !important;
            border-radius: 4px !important;
          }
          toolbarbutton[checked="true"] {
            background-color: var(--tn-bg-hl) !important;
            color: var(--tn-blue) !important;
          }

          .tab-line { background-color: var(--tn-blue) !important; }
        '';
      };
    };
  };
}
