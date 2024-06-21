{ ... }:
let
  listenPort = 51820;
in
{
  networking.firewall.allowedUDPPorts = [ listenPort ];

  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.2.101/32" ];
    listenPort = listenPort;

    privateKeyFile = "/run/secrets/wg/hermes/private";

    peers = [
      {
        publicKey = "tZig7C6g9oeWb2N7xF+GH8XvKGedhxwvwyyHoTMaOi4=";
        allowedIPs = [ "0.0.0.0/0" ];

        endpoint = "vpn.chase-dorsey.com:51820";

        persistentKeepalive = 25;
      }
    ];
  };
}
