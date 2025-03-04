{ inputs, config, pkgs, lib, username, ... }:

      let commandOptions = {
            retry = "3";
            batch = "true";
            repeat = "watch+30";
            ui = "text";
          };
      in
 
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
  hyprland-home.enable = true;

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };
  games.enable = true;
  home.sessionPath = [ "./scripts" ];




  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.kdePackages.breeze;
    name = "Breeze";
    size = 32;
  };

  services = {
    unison = {
      enable = true;
     pairs = {
        Configuration = {
          roots = [ "ssh://208.107.201.148//srv/shares/Users/Silverdev2482/Configuration" "/home/${username}/Configuration" ];
          inherit commandOptions;
        };
        Programming = {
          roots = [ "ssh://208.107.201.148//srv/shares/Users/Silverdev2482/Programming" "/home/${username}/Programming" ];
          inherit commandOptions;
        Sync = {
          roots = [ "ssh://208.107.201.148//srv/shares/Users/Silverdev2482/Sync" "/home/${username}/Sync" ];
          inherit commandOptions;
        };
      };
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "silverdev2482";
      userEmail = "fidget1206@gmail.com";
    };
    kitty = {
      enable = true;
      theme = "Gruvbox Dark";
    };
  };
  home.file = {
    ".config/discord/settings.json".source = ./modules/misc/discord.json;
    ".config/hypr/hyprpaper.conf".source = ./modules/hyprland/hyprpaper.conf;
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
    kdePackages.dolphin
    filezilla
    firefox-wayland
    qalculate-gtk
    kitty
    keepassxc
    qpwgraph
    easyeffects
#    freecad
    gimp
    prusa-slicer
    element-desktop

    # Libraries/anything that I don't directly invoke

    SDL2
    wireguard-tools
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
