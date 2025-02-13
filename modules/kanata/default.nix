{ config, ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default = {
      configFile = ./colemak-dhm.kbd;
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
    };
  };
}
