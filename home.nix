{ inputs, config, pkgs, lib, username, ... }:

let

in


{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "Silverdev2482";
  home.homeDirectory = "/home/Silverdev2482";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
#  hyprland-home.enable = true;

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };
  games.enable = true;
  home.sessionPath = [ "./scripts" ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };



  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.kdePackages.breeze;
    name = "Breeze";
    size = 32;
  };

  services = let 
    mkUnison =
      {
        directory
      }:
      {
        ${directory} = {
           roots = [ "ssh://kf0nlr.radio//srv/shares/Users/${username}/${directory}" "/home/${username}/${directory}" ];
            commandOptions = {
              retry = "3";
              batch = "true";
              repeat = "watch+30";
              ui = "text";
            };
          };
        };
  in
  {
    unison = {
      enable = true;
      pairs = 
        mkUnison { directory = "Configuration"; } //
        mkUnison { directory = "Programming"; } //
        mkUnison { directory = "Sync"; }
      ;
    };
  };

  programs = {
    git = {
      enable = true;
      signing.format = "openpgp";
      settings = {
        user = {
          name = "Silverdev2482";
          email = "fidget1206@gmail.com";
        };
      };
    };
    kitty = {
      enable = true;
      themeFile = "gruvbox-dark";
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        rm = "rmxt";
        ls = "eza";
      };
      history.size = 10000;
      zplug = {
        enable = true;
        plugins = [
#          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
#          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
        ];
      };
#      initContent = ''
#        source ~/.config/p10k/p10k.zsh
#      '';
    };
  };
  home.file = {
    ".config/discord/settings.json".source = ./modules/misc/discord.json;
    ".config/hypr/hyprpaper.conf".source = ./modules/hyprland/hyprpaper.conf;
    ".config/p10k/p10k.zsh".source = ./files/p10k.zsh;
  };



  home.packages = with pkgs; [
    # TUI/CLI Tools and applications or any GUI application normally invoked from the command line

    eza
    ddcutil
    signal-desktop
#    anki
    vesktop
    weechat
    brightnessctl # Controling brightnesses
    moonlight-qt
    mangohud
    inputs.fan.packages.${pkgs.system}.fan
    glow
    poppler-utils
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
    nvtopPackages.intel
    packwiz
    zathura
    yt-dlp
    nvd
    nix-index
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
    traceroute

    # Desktop appplicatons

    kdePackages.dolphin
    filezilla
    firefox
    qalculate-gtk
    kitty
    keepassxc
    qpwgraph
    easyeffects
#    freecad
    gimp
    prusa-slicer
    element-desktop
    zoom-us

    # Libraries/anything that I don't directly invoke

    SDL2
    wireguard-tools
    mimalloc
    winetricks
    #winePackages.waylandFull
    wine64Packages.waylandFull
    glibc
    bluez
    blueman
    harper

    # Compositing

    obs-studio
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
