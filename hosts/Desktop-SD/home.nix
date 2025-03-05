{ inputs, config, pkgs, lib, ... }:

{
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
    filezilla
    firefox-wayland
    qalculate-gtk
    qalculate-qt
    kitty
    keepassxc
    qpwgraph
    easyeffects
    freecad
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
