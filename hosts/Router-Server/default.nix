{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./router.nix
    ./dns.nix
  ];
}
