{
  config,
  pkgs,
  lib,
  inputs24router-lib,
  addresses,
  ...
}: {


  hardware.infiniband = {
    enable = true;
    guids = [ "0xf452140300921801" ];
  };

  router = {
    interfaces = {
      wan0 = {
        dhcpcd = {
          enable = true;
          extraConfig = ''
            noipv6rs
            waitip 6
            interface wan0
              ipv6rs
              iaid 1
              ia_na 1
              ia_pd 2 br0/0/64
              ia_pd 2 ibs1/1/64
              ia_pd 2 wan-direct-vpn/3/64
              ia_pd 2 russian-vpn/4/64
          '';
        };
      };
      ibs1 = {
        dhcpcd.enable = false;
        ipv6 = {
          # Doesn't work on infiniband, nor does kea.
          corerad = {
            # enable = true;
            interfaceSettings = {
              prefix = [
                {
                  autonomous = true;
                  prefix = addresses.inf.ULASpace;
                }
                {
                  autonomous = true;
                  prefix = addresses.inf.PDSpace;
                }
              ];
            };
          };
        };
      };
      br0 = {
        dhcpcd.enable = false;
        ipv4 = {
          kea = {
            enable = true;
            settings = {
              lease-database = {
                name = "/var/lib/private/kea/dhcp4.leases";
                persist = true;
                type = "memfile";
              };
              client-classes = [
                {
                  name = "iPXE";
                  test = "option[175].exists";
                  option-data = [
                    {
                      name = "boot-file-name";
                      data = "http://boot.netboot.xyz";
                    }
                  ];
                }
                {
                  name = "HTTPClient";
                  test = "substring(option[60].hex,0,10) == 'HTTPClient'";
                  option-data = [
                    {
                      name = "vendor-class-identifier";
                      data = "HTTPClient";
                      always-send = true;
                    }
                    {
                      name = "boot-file-name";
                      data = "http://insecure-infrastructure.kf0nlr.radio/ipxe.efi";
                    }
                  ];
                }
                {
                  name = "UEFI clients";
                  test = "option[93].hex == 0x0007 and not option[175].exists";
                  option-data = [
                    {
                      name = "tftp-server-name";
                      data = "10.48.0.1";
                    }
                    {
                      name = "boot-file-name";
                      data = "ipxe.efi";
                    }
                  ];
                }
              ];
            };
          };
        };
        ipv6 = {
          corerad = {
            enable = true;
            interfaceSettings = {
              managed = false;
              other_config = true;
              prefix = [
                {
                  autonomous = true;
                  prefix = addresses.lan.ULASpace;
                }
                {
                  autonomous = true;
                  prefix = addresses.lan.PDSpace;
                }
              ];
            };
          };
          kea = {
            enable = true;
            settings = {
              lease-database = {
                name = "/var/lib/private/kea/dhcp6.leases";
                persist = true;
                type = "memfile";
              };
              client-classes = [
                {
                  name = "iPXE";
                  test = "substring(option[16].hex,0,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "bootfile-url";
                      data = "http://[${addresses.router.ULAAddress}]/boot.ipxe";
                    }
                  ];
                }
                {
                  name = "HTTPClient";
                  test = "substring(option[16].hex,0,10) == 'HTTPClient' and not substring(option[16].hex,0,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "bootfile-url";
                      data = "http://[${addresses.router.ULAAddress}]/ipxe.efi";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };


}

