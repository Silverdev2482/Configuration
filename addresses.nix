rec {

  mkIPv6Pool = prefix: "${prefix}::1:0 - ${prefix}:ffff:ffff:ffff:0000";


  all = {
    v4Space = "10.48.0.0/16";

    PDPrefix = "2605:4a80:2500:20d";
    PDSpace = all.PDPrefix + "0::/60";
    ULAPrefix = "fd99:2673:4614";
    ULASpace = all.ULAPrefix + "::/48";
  };

  router = {
    v4PublicAddress = "208.107.235.245";

    PDAddress = switch.PDPrefix + "::1";
    PDSpace = switch.PDPrefix + "::/61";
    ULAAddress = switch.ULAPrefix + "::1";
    ULASpace = switch.ULAPrefix + "::/52";
  };

  switch = {
    v4Prefix = "10.48.";
    v4Space = switch.v4Prefix + "0.0/18";
    v4Address = switch.v4Prefix + "0.1";
    v4Length = 18;
    v4Pool = "10.48.1.17 - 10.48.1.254";

    PDPrefix = all.PDPrefix + "0";
    PDSpace = all.PDPrefix + "0::/64";
    PDAddress = switch.PDPrefix + "::1";
    PDPool = mkIPv6Pool switch.PDPrefix;
    ULAPrefix = all.ULAPrefix + ":0"; # Redundant if you use ::, but kept for caution.
    ULASpace = all.ULAPrefix + "::/64";
    ULAAddress = switch.ULAPrefix + "::1";
    ULAPool = mkIPv6Pool switch.ULAPrefix;
  };

  camera = {
    v4Prefix = "10.48.65";
    v4Space = camera.v4Prefix + ".0/24";
    v4Address = camera.v4Prefix + ".1";
    v4Length = 24;
    v4Pool = "10.48.65.17 - 10.48.65.239";

    ULAPrefix = all.ULAPrefix + ":10";
    ULASpace = all.ULAPrefix + ":10::/64";
    ULAAddress = all.ULAPrefix + ":10::1";
    ULAPool = mkIPv6Pool camera.ULAPrefix;
  };

  inf = {
    v4Prefix = "10.48.64";
    v4Space = inf.v4Prefix + ".0/24";

    PDPrefix = all.PDPrefix + "1";
    PDSpace = all.PDPrefix + "1::/64";
    ULAPrefix = all.ULAPrefix + ":1";
    ULASpace = all.ULAPrefix + ":1::/64";
  };

  netns = {
    ULAPrefix = all.ULAPrefix + ":4";
    ULASpace = all.ULAPrefix + ":4::/64";
  };

  lanVPN = {
    v4Prefix = "10.48.224";

    ULAPrefix = all.ULAPrefix + ":2";
    ULASpace = all.ULAPrefix + ":2::/64";
  };

  wanDirectVPN = {
    v4Prefix = "10.48.128";
    v4Space = "10.48.128.0/24";

    ULAPrefix = all.ULAPrefix + ":3";
    ULASpace = all.ULAPrefix + ":3::/64";
    PDPrefix = all.PDPrefix + "3";
    PDSpace = all.PDPrefix + "3::/64";
  };

  russianVPN = {
    v4Prefix = "10.48.160";
    v4Space = "10.48.160.0/24";

    ULAPrefix = all.ULAPrefix + ":5";
    ULASpace = all.ULAPrefix + ":5::/64";
    PDPrefix = all.PDPrefix + "5";
    PDSpace = all.PDPrefix + "5::/64";
  };

  internalAddresses = [
    "127.0.0.0/8"
    "::1/128"
    all.v4Space
    all.PDSpace
    all.ULASpace
  ];
}
