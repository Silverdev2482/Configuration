{
  config,
  pkgs,
  lib,
  inputs,
  inputs24router-lib,
  addresses,
  ...
}: {


  hardware.infiniband = {
    enable = true;
    guids = [ "0xf452140300921801" ];
  };
  systemd.services.rs-tftpd = {
    description = "tftpd-hpa TFTP server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = ''${pkgs.rs-tftpd}/bin/tftpd -r -d "/srv/www/Infrastructure" -i ::'';
      Type = "simple";
    };
  };
  systemd.tmpfiles.rules = [
    "L+ /srv/www/Infrastructure/Images/NixOS-x86_64 - - - - ${inputs.self.Netboot}"
  ];


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
                  test = "substring(option[77].hex,0,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "boot-file-name";
                      data = "https://kf0nlr.radio/Infrastructure/menu.ipxe";
                    }
                  ];
                }
                {
                  name = "HTTPClient-x86_64";
                  test = "substring(option[60].hex,0,20) == 'HTTPClient:Arch:0010' and not substring(option[77].hex,0,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "vendor-class-identifier";
                      data = "HTTPClient";
                      always-send = true;
                    }
                    {
                      name = "boot-file-name";
                      data = "http://insecure-infrastructure.kf0nlr.radio/ipxe-x86_64.efi";
                    }
                  ];
                }
                {
                  name = "PXEClient-x86_64";
                  test = "substring(option[60].hex,0,20) == 'PXEClient:Arch:00007' and not substring(option[77].hex,0,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "tftp-server-name";
                      data = "10.48.0.1";
                    }
                    {
                      name = "boot-file-name";
                      data = "ipxe-x86_64.efi";
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
              managed = true;
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
                  test = "substring(option[15].hex,2,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "bootfile-url";
                      data = "https://kf0nlr.radio/Infrastructure/menu.ipxe";
                    }
                  ];
                }
                {
                  name = "HTTPClient";
                  test = "substring(option[16].hex,6,20) == 'HTTPClient:Arch:0010' and not substring(option[15].hex,2,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "bootfile-url";
                      data = "http://insecure-infrastructure.kf0nlr.radio/ipxe-x86_64.efi";
                    }
                  ];
                }
                {
                  name = "PXEClient";
                  test = "substring(option[16].hex,6,20) == 'PXEClient:Arch:00007' and not substring(option[15].hex,2,4) == 'iPXE'";
                  option-data = [
                    {
                      name = "bootfile-url";
                      data = "tftp://[${addresses.router.ULAAddress}]/ipxe-x86_64.efi";
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

