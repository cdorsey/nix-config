{
  config,
  inputs,
  pkgs,
  ...
}:
let
  asHours = days: toString (days * 24) + "h";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    curl
  ];

  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 80;
    openFirewall = true;
    settings = {
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
            "https://v.firebog.net/hosts/static/w3kbl.txt"
            "https://adaway.org/hosts.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
            "https://phishing.army/download/phishing_army_blocklist_extended.txt"
            "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
            "https://v.firebog.net/hosts/Prigent-Crypto.txt"
            "https://v.firebog.net/hosts/RPiList-Malware.txt"
            "https://v.firebog.net/hosts/RPiList-Phishing.txt"
          ];

      dns = {
        # bind_hosts = [ "0.0.0.0" ];

        upstream_dns = [
          "https://dns.quad9.net/dns-query"
          "[/in-addr.arpa/]192.168.1.1"
          "[/ip6.arpa/]192.168.1.1"
        ];

        bootstrap_dns = [
          "9.9.9.10"
          "1.1.1.1"
        ];
        use_private_ptr_resolvers = true;
        local_ptr_upstreams = [ "192.168.1.1" ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        rewrites = [
          {
            domain = "*.homelab.chase-dorsey.com";
            answer = "192.168.1.9";
          }
        ];
      };

      querylog = {
        enabled = true;
        interval = asHours 7;
      };

      statistics = {
        enabled = true;
        interval = "24h";
      };

      users = [
        {
          name = "admin";
          password = "$2y$10$uK4ClhQKSm3kJve8XwlMC.rIGcqapwQ6.NB50OL1.NMVbuZeKLMJS";
        }
      ];
    };
  };

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets = {
    atlas-adguard.file = ../../secrets/atlas-adguard.age;
  };

  users.users.adguard = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secrets.atlas-adguard.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILbIEuBf2A6nJJZeCDEyoT4JErJXIpGWFfzK+oTqfmbJ"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  networking = {
    nameservers = [ "192.168.1.1" ];
    hostName = "atlas";
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  system.stateVersion = "24.05";
}
