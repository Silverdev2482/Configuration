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

    home.pointerCursor = 
    let 
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 28;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
        };
    in
      getFrom 
        "https://github.com/rose-pine/cursor/releases/download/v1.1.0/BreezeX-RosePine-Linux.tar.xz"
        "sha256-t5xwAPGhuQUfGThedLsmtZEEp1Ljjo3Udhd5Ql3O67c="
        "rose-pine-cursor";

  home.file = {
    ".config/discord/settings.json".source = ../../modules/misc/discord.json;
    ".config/hypr/hyprpaper.conf".source = ../../modules/hyprland/hyprpaper.conf;
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
    signal-desktop
    poppler_utils
#   localsend
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

    # Desktop appplicatons

#    qbittorrent
    deluge
    dolphin
    filezilla
    firefox-wayland
    qalculate-gtk
    qalculate-qt
    kitty
    keepassxc
    qpwgraph
    easyeffects
#    freecad
    gimp
    prusa-slicer
    lxqt.pavucontrol-qt
    virt-manager

    # Libraries/anything that I don't directly invoke

    SDL2
    wireguard-tools
    waybar
    wine-wayland
    mimalloc
    winetricks
    glibc
    bluez
    blueman


    # Compositing

    obs-studio-plugins.obs-pipewire-audio-capture
#    eww
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
