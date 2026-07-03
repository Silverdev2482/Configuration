{
  config,
  pkgs,
  lib,
  inputs,
  addresses,
  ...
}:

{

  networking.nameservers = [ "::1" ];

  services = {
    bind = {
      enable = true;
      forwarders = [
        "2606:4700:4700::1111" # Cloudflare main
        "2606:4700:4700::1001" # Cloudflare backup
        "2620:fe::fe" # Quad9 Main
        "2620:fe::9" # Quad9 Backup
        "1.1.1.1" # Cloudflare main
        "1.0.0.1" # Cloudflare backup
        "9.9.9.9" # Quad9 Main
        "149.112.112.112" # Quad9 Backup
      ];
      cacheNetworks = addresses.internalAddresses;
      extraConfig = ''
        include "${config.age.secrets.bind-acme-key.path}";
        include "${config.age.secrets.bind-dhcp-ddns-key.path}";
      '';
      checkConfig = false;
      zones = {
        "kf0nlr.radio" = {
          master = true;
          file = "/etc/bind/zones/kf0nlr.radio.internal.zone";
          extraConfig = "allow-update { key acme-key; };";
        };
        "hosts.kf0nlr.radio" = {
          master = true;
          file = "/etc/bind/zones/hosts.kf0nlr.radio.internal.zone";
          extraConfig = "allow-update { key dhcp-ddns-key; };";
        };
        "4.1.6.4.3.7.6.2.9.9.d.f.ip6.arpa" = {
          master = true;
          file = "/etc/bind/zones/rdns.ula.zone";
          extraConfig = "allow-update { key dhcp-ddns-key; };";
        };
        "d.0.2.0.0.5.2.0.8.a.4.5.0.6.2.ip6.arpa" = {
          master = true;
          file = "/etc/bind/zones/rdns.pd.zone";
          extraConfig = "allow-update { key dhcp-ddns-key; };";
        };
        "48.10.in-addr.arpa" = {
          master = true;
          file = "/etc/bind/zones/rdns.ipv4.zone";
          extraConfig = "allow-update { key dhcp-ddns-key; };";
        };
      };
    };

    kea.dhcp-ddns = {
      enable = true;
      settings = {
        ip-address = "::1";
        tsig-keys = [
          {
            name = "dhcp-ddns-key";
            algorithm = "HMAC-SHA256";
            secret = "KEA-DHCP-DDNS-KEY-PLACEHOLDER";
          }
        ];
        forward-ddns = {
          ddns-domains = [
            {
              name = "hosts.kf0nlr.radio.";
              key-name = "dhcp-ddns-key";
              dns-servers = [
                { ip-address = "::1"; port = 53; }
              ];
            }
          ];
        };
        reverse-ddns = {
          ddns-domains = [
            {
              name = "4.1.6.4.3.7.6.2.9.9.d.f.ip6.arpa.";
              key-name = "dhcp-ddns-key";
              dns-servers = [
                { ip-address = "::1"; port = 53; }
              ];
            }
            {
              name = "d.0.2.0.0.5.2.0.8.a.4.5.0.6.2.ip6.arpa.";
              key-name = "dhcp-ddns-key";
              dns-servers = [
                { ip-address = "::1"; port = 53; }
              ];
            }
            {
              name = "48.10.in-addr.arpa.";
              key-name = "dhcp-ddns-key";
              dns-servers = [
                { ip-address = "::1"; port = 53; }
              ];
            }
          ];
        };
      };
    };
  };

  systemd = {
    services = {
      kea-dhcp-ddns-server = {
        serviceConfig.ExecStartPre = pkgs.writeShellScript "kea-ddns-prestart" ''
          secret=$(cat ${config.age.secrets.kea-dhcp-ddns-key.path})
          sed "s|KEA-DHCP-DDNS-KEY-PLACEHOLDER|$secret|" /etc/kea/dhcp-ddns.conf > /run/kea/dhcp-ddns.conf
        '';
        serviceConfig = {
          ExecStart = lib.mkForce "${pkgs.kea}/bin/kea-dhcp-ddns -c /run/kea/dhcp-ddns.conf";
          ExecStopPost = "${pkgs.coreutils}/bin/rm -f /run/kea/dhcp-ddns.conf";
        };
      };
    };
  };

  system.activationScripts.bind-zones.text = ''
    mkdir -p /etc/bind
    chown named:named /etc/bind
  '';

  environment.etc = {
    "bind/zones/kf0nlr.radio.internal.zone" = {
      enable = true;
      user = "named";
      group = "named";
      mode = "0644";
      text = ''
        $ORIGIN kf0nlr.radio.
        $TTL      300 ; 5 min
        @         IN      SOA         kf0nlr.radio. fidget1206.gmail.com. (
                          2025081701  ; Serial
                          3h          ; Refresh after 3 hours
                          1h          ; Retry after 1 hour
                          1w          ; Expire after 1 week
                          1h )        ; Negative caching TTL of 1 day

        @         IN      NS      ns1.kf0nlr.crabdance.com.
        @         IN      NS      ns2.kf0nlr.crabdance.com.

        @         IN      A       ${addresses.router.v4PublicAddress}
        @         IN      AAAA    ${addresses.router.PDAddress}
        @         IN      AAAA    ${addresses.router.ULAAddress}

        dyn       IN      A       ${addresses.router.v4PublicAddress}
        dyn       IN      AAAA    ${addresses.router.PDAddress}

        astraeus  IN      A       ${addresses.router.v4PublicAddress}
        astraeus  IN      AAAA    ${addresses.router.PDAddress}

        test      IN      AAAA    ::1

        Router-Server.hosts IN CNAME @
        insecure-infrastructure  IN CNAME @
        qbittorrent-public.services  IN CNAME @
        qbittorrent-private.services  IN CNAME @
        jellyfin.services  IN CNAME @
        kiwix.services  IN CNAME @
        home-assistant.services  IN CNAME @
        harmonia.services  IN CNAME @
        frigate.services  IN CNAME @
        otbr.services  IN CNAME @
      '';
    };
    "bind/zones/hosts.kf0nlr.radio.internal.zone" = {
      enable = true;
      user = "named";
      group = "named";
      mode = "0644";
      text = ''
        $ORIGIN hosts.kf0nlr.radio.
        $TTL      300 ; 5 min
        @         IN      SOA         kf0nlr.radio. fidget1206.gmail.com. (
                          2025081701  ; Serial
                          3h          ; Refresh after 3 hours
                          1h          ; Retry after 1 hour
                          1w          ; Expire after 1 week
                          1h )        ; Negative caching TTL of 1 day
        @ IN NS kf0nlr.radio.

        Router-Server IN CNAME kf0nlr.radio.
      '';
    };
#    "bind/zones/rdns.ula.zone" = {
#      enable = true;
#      user = "named";
#      group = "named";
#      mode = "0644";
#      text = ''
#        $ORIGIN 4.1.6.4.3.7.6.2.9.9.d.f.ip6.arpa.
#        $TTL      300 ; 5 min
#        @         IN      SOA         kf0nlr.radio. fidget1206.gmail.com. (
#                          2025081701  ; Serial
#                          3h          ; Refresh after 3 hours
#                          1h          ; Retry after 1 hour
#                          1w          ; Expire after 1 week
#                          1h )        ; Negative caching TTL of 1 day
#        @ IN NS kf0nlr.radio.
#
#        1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0 IN PTR kf0nlr.radio.
#      '';
#    };
#    "bind/zones/rdns.pd.zone" = {
#      enable = true;
#      user = "named";
#      group = "named";
#      mode = "0644";
#      text = ''
#        $ORIGIN d.0.2.0.0.5.2.0.8.a.4.5.0.6.2.ip6.arpa.
#        $TTL      300 ; 5 min
#        @         IN      SOA         kf0nlr.radio. fidget1206.gmail.com. (
#                          2025081701  ; Serial
#                          3h          ; Refresh after 3 hours
#                          1h          ; Retry after 1 hour
#                          1w          ; Expire after 1 week
#                          1h )        ; Negative caching TTL of 1 day
#        @ IN NS kf0nlr.radio.
#
#        1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0  IN PTR kf0nlr.radio.
#      '';
#    };
#    "bind/zones/rdns.ipv4.zone" = {
#      enable = true;
#      user = "named";
#      group = "named";
#      mode = "0644";
#      text = ''
#        $ORIGIN 48.10.in-addr.arpa.
#        $TTL      300 ; 5 min
#        @         IN      SOA         kf0nlr.radio. fidget1206.gmail.com. (
#                          2025081701  ; Serial
#                          3h          ; Refresh after 3 hours
#                          1h          ; Retry after 1 hour
#                          1w          ; Expire after 1 week
#                          1h )        ; Negative caching TTL of 1 day
#        @ IN NS kf0nlr.radio.
#
#        1.0  IN PTR kf0nlr.radio.
#      '';
#    };
  };
}
