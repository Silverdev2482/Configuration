{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./router.nix
    ./ra-dhcp-pxe.nix
    ./dns.nix
  ];
}
