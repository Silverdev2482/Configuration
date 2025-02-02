{ inputs, config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "silverdev2482";
  home.homeDirectory = "/home/silverdev2482";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };
  games.enable = true;
  home.sessionPath = [ "./scripts" ];

  programs = {
    git = {
      enable = true;
      userName = "silverdev2482";
      userEmail = "fidget1206@gmail.com";
    };
  };
  home.file = {
    ".config/sway/config".source = ./config/sway;
    ".config/discord/settings.json".source = ./config/discord.json;
    ".config/hypr/hyprland.conf".source = ./config/hyprland.conf;
    ".config/hypr/hyprpaper.conf".source = ./config/hyprpaper.conf;
  };




  wayland.windowManager.hyprland = {
#    extraConfig = builtins.readfile
#    settings = {
#      "$left" = "n";
#      "$down" = "e";
#      "$up" = "i";
#      "$right" = "o";
#      "$mod" = "SUPER";
#      exec-once = gnome-calls -d
#      bind = [
#      ]
#      ++ (
#        # workspaces
#        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
#        builtins.concatLists (builtins.genList (i:
#            let ws = i + 1;
#            in [
#              "$mod, code:1${toString i}, workspace, ${toString ws}"
#              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
#            ]
#          )
#        9)
#      );
#    };
  };











  home.packages = with pkgs; [
    # TUI/CLI Tools and applications or any GUI application normally invoked from the command line

    ddcutil
#    anki
    discord-canary
    weechat
    brightnessctl # Controling brightnesses
    moonlight-qt
    mangohud
    inputs.fan.packages.${pkgs.system}.fan
    glow
    poppler_utils
    libsForQt5.breeze-icons
    localsend
    mmsd-tng
    gitui
    gh
    kexec-tools
    bcachefs-tools
    phoronix-test-suite
    pciutils
    jq
    grim
    obs-studio
    neofetch
    nvtopPackages.intel
    packwiz
    zathura
    yt-dlp
    nvd
    nix-index
    ipfs
    mpv
    patchelf
    libqalculate
    bemenu
    mdbook
    rustup
    flatpak
    protontricks
    pwvucontrol
    texliveFull
    sl
    python313Full
    traceroute

    # Desktop appplicatons

#    qbittorrent
    deluge
    dolphin
    filezilla
    firefox-wayland
    qalculate-gtk
    kitty
    keepassxc
    qpwgraph
    easyeffects
    freecad
    gimp
    prusa-slicer
    lxqt.pavucontrol-qt
    virt-manager
    element-desktop

    # Libraries/anything that I don't directly invoke

    SDL2
    wireguard-tools
    waybar
    hyprpaper
    mimalloc
    winetricks
    glibc
    bluez
    blueman


    # Compositing

    obs-studio-plugins.obs-pipewire-audio-capture
    eww
    wayland
    libdrm
    slurp
    wl-clipboard
    dunst
    alacritty
    kitty
    mesa
    clipboard-jh

    # Radio

#    gnuradio
    rtl_433
    sdrpp
    rtl-sdr


    # Misc
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
