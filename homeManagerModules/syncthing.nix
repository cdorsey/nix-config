{ lib, config, ... }:
{
  config.services.syncthing = {
    enable = true;
  };
}
