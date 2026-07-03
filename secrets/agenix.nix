{ inputs, config, pkgs, lib, agenix, ... }:
let
  secretNames = [
    "user-password"
    "router-vpn-private-key"
    "commercial-vpn-preshared-key"
    "commercial-vpn-private-key"
    "bind-acme-key"
    "acme-key"
    "camera-password"
    "bind-dhcp-ddns-key"
    "kea-dhcp-ddns-key"
  ];
  
  secrets = lib.recursiveUpdate
    (lib.genAttrs secretNames (name: {
      file = ./${name}.age;
    }))
    {
      bind-acme-key.owner = "named";
      bind-dhcp-ddns-key.owner = "named";
      kea-dhcp-ddns-key.owner = "kea";
    };
in
{
  age = {
    inherit secrets;
  };
}
