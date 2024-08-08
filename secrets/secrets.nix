let
  userPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILbIEuBf2A6nJJZeCDEyoT4JErJXIpGWFfzK+oTqfmbJ";
  hermesPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBFDeimCcHBlt9baBWr1KPBPZfWYbis1kOzvQshJqtP";
in
{
  "smb.age".publicKeys = [
    userPublicKey
    hermesPublicKey
  ];
  "ssh-keys/hermes.age".publicKeys = [
    userPublicKey
    hermesPublicKey
  ];
  "ssh-keys/chase.age".publicKeys = [
    userPublicKey
    hermesPublicKey
  ];
  "ssh-keys/chase.legacy.age".publicKeys = [
    userPublicKey
    hermesPublicKey
  ];
}
