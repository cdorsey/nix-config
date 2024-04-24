# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      gnome.gnome-tweaks
      gnome-extension-manager
      wget
      git
      vim-full
    ] ++ [ (import ./scripts/nixos-switch.nix { inherit pkgs; }) ];

  users.users.chase = {
    isNormalUser = true;
    description = "Chase Dorsey";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
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
      _1password
      _1password-gui
      neovim
      nil
      signal-desktop
    ];
  };

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${config.users.users.chase.home}/.config/sops/age/keys.txt";

  sops.secrets = {
    smb = { };
  };

  fileSystems = let
    host = "//192.168.1.9";
    fsType = "cifs";
    credentials = "/run/secrets/smb";
    automount-opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  in {
    "/mnt/media" = {
      inherit fsType;
      device = "${host}/media";
      options = ["${automount-opts},credentials=${credentials}"];
    };

    "/mnt/backup" = {
      inherit fsType;
      device = "${host}/backup";
      options = ["${automount-opts},credentials=${credentials}"];
    };
  };

    

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  services.samba.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Configure fingerprint reader.
  services.fprintd = {
    enable = true;

    #tod = {
    #  enable = true;
    #  driver = pkgs.libfprint-2-tod1-goodix;
    #};
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs.zsh.enable = true;

  programs.neovim.enable = true;

  programs.nh = {
    enable = true;

    flake = "${config.users.users.chase.home}/.dotfiles";

    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 9512 9510 ];
  networking.firewall.allowedUDPPorts = [ 9512 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
# ----
