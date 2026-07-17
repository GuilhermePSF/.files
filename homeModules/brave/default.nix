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

    xdg.configFile."BraveSoftware/Brave-Browser/policies/managed/policy.json".text = builtins.toJSON {
      HomepageLocation = "about:blank";
      HomepageIsNewTabPage = false;
      RestoreOnStartup = 1;
      NewTabPageLocation = "about:blank";
      HttpsOnlyMode = "force_enabled";
      SafeBrowsingEnabled = true;
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      SearchSuggestEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      MetricsReportingEnabled = false;
      CloudReportingEnabled = false;
      ShowHomeButton = false;
      BookmarkBarEnabled = true;
      FullscreenAllowed = true;
      ForceDarkModeEnabled = true;
      DefaultColorScheme = 2;
      ExtensionInstallForcelist = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        "nngceckbapebfimnlniiiahkandclblb"
        "bkkmolkhemgaeaeggcmcolemnnmmixed"
      ];
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Brave";
      DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
    };
  };
}
