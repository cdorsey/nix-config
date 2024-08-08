{
  config,
  pkgs,
  root-dir,
  inputs,
  ...
}:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./hardware-configuration.nix
    #../../nixosModules/wireguard.nix
    ../../nixosModules/1password.nix
    ../../nixosModules/firefox.nix
    ../../nixosModules/nh.nix
    ../../nixosModules/ssh.nix
  ];

  myNixOS = {
    flakePath = "${config.users.users.chase.home}/.dotfiles";
  };

  environment.systemPackages =
    with pkgs;
    [
      gnome.gnome-tweaks
      gnome-extension-manager
      wget
      git
      gcc
      nodejs
      fd
      wl-clipboard
      vim
      inputs.agenix.packages.${pkgs.system}.default

      cifs-utils
    ]
    ++ [ (import (root-dir + /scripts/nixos-switch.nix) { inherit pkgs; }) ];

  users.users.chase = {
    isNormalUser = true;
    description = "Chase Dorsey";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      vlc
      xh
      bat
      eza
      ripgrep
      fzf
      zoxide
      zellij
      jq
      yq
      sops
      nixfmt-rfc-style
      jujutsu
      alacritty
      neovim
      signal-desktop
    ];
  };

  age.secrets = {
    smb.file = ../../secrets/smb.age;
  };

  fileSystems =
    let
      host = "//192.168.1.9";
      fsType = "cifs";
      credentials = config.age.secrets.smb.path;
      uid = toString config.users.users.chase.uid;
      gid = toString config.users.groups.users.gid;
      automount-opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
    in
    {
      "/mnt/media" = {
        inherit fsType;
        device = "${host}/media";
        options = [ "${automount-opts},credentials=${credentials},rw,uid=1000,gid=${gid}" ];
      };

      "/mnt/backup" = {
        inherit fsType;
        device = "${host}/backup";
        options = [ "${automount-opts},credentials=${credentials},rw,uid=1000,gid=${gid}" ];
      };
    };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hermes";

  networking.networkmanager.enable = true;

  time.timeZone = "US/Eastern";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services.samba.enable = true;

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.printing.enable = true;

  services.fwupd.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  programs.neovim.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };

  networking.firewall.allowedTCPPorts = [
    # Syncthing
    22000
    # Unified Remote
    9512
    9510
  ];
  networking.firewall.allowedUDPPorts = [
    # Unified Remote
    9512
    # Syncthing
    22000
    21027
  ];

  system.stateVersion = "23.11";
}
