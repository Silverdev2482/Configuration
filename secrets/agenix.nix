{ inputs, config, pkgs, lib, agenix, ... }:
let
  secretNames = [
    "user-password"
    "router-vpn-private-key"
    "commercial-vpn-preshared-key"
    "commercial-vpn-private-key"
  ];
  
  secrets = lib.genAttrs secretNames (name: {
    file = ./secrets/${name}.age;
  });
in
{
  age = {
    inherit secrets;
  };
}
