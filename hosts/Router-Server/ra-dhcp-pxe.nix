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
  
  services = {
    kea = {
      dhcp4 = {
        enable = true;
        settings = {
          lease-database = {
            name = "/var/lib/kea/dhcp4.leases";
            persist = true;
            type = "memfile";
          };
          interfaces-config = {
            interfaces = [
              "switch"
            ];
          };
          client-classes = [
            {
              name = "iPXE";
              option-data = [
                {
                  data = "https://kf0nlr.radio/Infrastructure/menu.ipxe";
                  name = "boot-file-name";
                }
              ];
              test = "substring(option[77].hex,0,4) == 'iPXE'";
            }
            {
              name = "HTTPClient-x86_64";
              option-data = [
                {
                  always-send = true;
                  data = "HTTPClient";
                  name = "vendor-class-identifier";
                }
                {
                  data = "http://insecure-infrastructure.kf0nlr.radio/ipxe-x86_64.efi";
                  name = "boot-file-name";
                }
              ];
              test = "substring(option[60].hex,0,20) == 'HTTPClient:Arch:0010' and not substring(option[77].hex,0,4) == 'iPXE'";
            }
            {
              name = "PXEClient-x86_64";
              option-data = [
                {
                  data = "10.48.0.1";
                  name = "tftp-server-name";
                }
                {
                  data = "ipxe-x86_64.efi";
                  name = "boot-file-name";
                }
              ];
              test = "substring(option[60].hex,0,20) == 'PXEClient:Arch:00007' and not substring(option[77].hex,0,4) == 'iPXE'";
            }
          ];
          subnet4 = [
            {
              id = 10;
              interface = "switch";
              option-data = [
                {
                  code = 6;
                  csv-format = true;
                  data = addresses.switch.v4Address + ", 1.1.1.1";
                  name = "domain-name-servers";
                  space = "dhcp4";
                }
                {
                  code = 3;
                  csv-format = true;
                  data = addresses.switch.v4Address;
                  name = "routers";
                  space = "dhcp4";
                }
              ];
              pools = [
                {
                  pool = addresses.switch.v4Pool;
                }
              ];
              reservations = [
                {
                  # Smart home radio
                  hw-address = "00:4b:12:96:6f:7f";
                  ip-address = "10.48.0.128";
                }
                {
                  # Printer
                  hw-address = "F0:A6:54:88:DE:8F";
                  ip-address = "10.48.0.130";
                }
                {
                  # Access point
                  hw-address = "D4:5D:64:7B:6B:60";
                  ip-address = "10.48.0.64";
                }
                {
                  # Access point
                  hw-address = "0C:9D:92:2C:4D:10";
                  ip-address = "10.48.0.65";
                }
              ];
              subnet = addresses.switch.v4Space;
            }
            {
              id = 20;
              interface = "camera";
              option-data = [
                {
                  code = 6;
                  csv-format = true;
                  data = addresses.camera.v4Address;
                  name = "domain-name-servers";
                  space = "dhcp4";
                }
                {
                  code = 3;
                  csv-format = true;
                  data = addresses.camera.v4Address;
                  name = "routers";
                  space = "dhcp4";
                }
              ];
              pools = [
                {
                  pool = addresses.camera.v4Pool;
                }
              ];
              subnet = addresses.camera.v4Space;
            }
          ];
          valid-lifetime = 4000;
        };
      };
      dhcp6 = {
        enable = true;
        settings = {
          client-classes = [
            {
              name = "iPXE";
              option-data = [
                {
                  data = "https://kf0nlr.radio/Infrastructure/menu.ipxe";
                  name = "bootfile-url";
                }
              ];
              test = "substring(option[15].hex,2,4) == 'iPXE'";
            }
            {
              name = "HTTPClient";
              option-data = [
                {
                  data = "http://insecure-infrastructure.kf0nlr.radio/ipxe-x86_64.efi";
                  name = "bootfile-url";
                }
              ];
              test = "substring(option[16].hex,6,20) == 'HTTPClient:Arch:0010' and not substring(option[15].hex,2,4) == 'iPXE'";
            }
            {
              name = "PXEClient";
              option-data = [
                {
                  data = "tftp://[fd99:2673:4614:0::1]/ipxe-x86_64.efi";
                  name = "bootfile-url";
                }
              ];
              test = "substring(option[16].hex,6,20) == 'PXEClient:Arch:00007' and not substring(option[15].hex,2,4) == 'iPXE'";
            }
          ];
          interfaces-config = {
            interfaces = [
              "switch"
              "camera"
            ];
          };
          lease-database = {
            name = "/var/lib/kea/dhcp6.leases";
            persist = true;
            type = "memfile";
          };
          dhcp-ddns = {
            enable-updates = true;
            server-ip = "::1";
          };
          ddns-qualifying-suffix = "hosts.kf0nlr.radio.";
          subnet6 = [
            {
              id = 10;
              interface = "switch";
              option-data = [
                {
                  code = 23;
                  data = addresses.switch.ULAAddress + ", 2606:4700:4700::1111";
                  name = "dns-servers";
                  space = "dhcp6";
                }
              ];
              pools = [
                {
                  pool = addresses.switch.ULAPool;
                }
              ];
              subnet = addresses.switch.ULASpace;
            }
            {
              id = 20;
              interface = "camera";
              option-data = [
                {
                  code = 23;
                  csv-format = true;
                  data = addresses.camera.ULAAddress;
                  name = "dns-servers";
                  space = "dhcp6";
                }
              ];
              pools = [
                {
                  pool = addresses.camera.ULAPool;
                }
              ];
              subnet = addresses.camera.ULASpace;
            }
          ];
          preferred-lifetime = 3000;
          valid-lifetime = 4000;
        };
      };
    };
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
              ia_pd 2 switch/0/64
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
      switch = {
        dhcpcd.enable = false;
        ipv6 = {
          corerad = {
            enable = true;
            interfaceSettings = {
              managed = true;
              other_config = true;
              prefix = [
                {
                  autonomous = true;
                  prefix = addresses.switch.ULASpace;
                }
                {
                  autonomous = true;
                  prefix = addresses.switch.PDSpace;
                }
              ];
              pref64 = [
                {
                  prefix = "64:ff9b::/96";
                }
              ];
            };
          };
        };
      };

      camera = {
        dhcpcd.enable = false;
        ipv6 = {
          corerad = {
            enable = true;
            interfaceSettings = {
              managed = true;
              other_config = true;
              prefix = [
                {
                  autonomous = true;
                  prefix = addresses.camera.ULASpace;
                }
              ];
            };
          };
        };
      };
    };
  };


}

