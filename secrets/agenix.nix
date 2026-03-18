{ inputs, config, pkgs, lib, agenix, ... }:
let
  secretNames = [
    "user-password"
    "router-vpn-private-key"
    "commercial-vpn-preshared-key"
    "commercial-vpn-private-key"
    "bind-acme-key"
    "acme-key"
  ];
  
  secrets = lib.recursiveUpdate
    (lib.genAttrs secretNames (name: {
      file = ./${name}.age;
    }))
    { bind-acme-key.owner = "named"; };
in
{
  age = {
    inherit secrets;
  };
}
