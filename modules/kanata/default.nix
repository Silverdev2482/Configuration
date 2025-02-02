{ config, ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default.configFile = ./colemak-dhm.kbd;
  };
}
