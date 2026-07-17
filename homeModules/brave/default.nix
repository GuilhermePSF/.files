{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.braveModule.enable = lib.mkEnableOption "Enable Brave Module";

  config = lib.mkIf config.braveModule.enable {

    home.packages = [ pkgs.brave ];

    # Managed policy file — covers most about:flags / settings
    xdg.configFile."BraveSoftware/Brave-Browser/policies/managed/policy.json".text = builtins.toJSON {
      # --- Homepage & Startup ---
      HomepageLocation = "about:blank";
      HomepageIsNewTabPage = false;
      RestoreOnStartup = 1; # 1 = restore last session
      NewTabPageLocation = "about:blank";

      # --- Privacy & Security ---
      HttpsOnlyMode = "force_enabled";
      SafeBrowsingEnabled = true;
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      SearchSuggestEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      MetricsReportingEnabled = false;
      CloudReportingEnabled = false;

      # --- UI ---
      ShowHomeButton = false;
      BookmarkBarEnabled = true;
      FullscreenAllowed = true;

      # --- Dark Mode ---
      ForceDarkModeEnabled = true;
      DefaultColorScheme = 2; # 2 = Dark

      # --- Extensions (auto-installed by ID) ---
      ExtensionInstallForcelist = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "bkkmolkhemgaeaeggcmcolemnnmmixed" # Sponsors Block for YouTube
      ];

      # --- Default Search (Brave Search) ---
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Brave";
      DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
    };
  };
}
