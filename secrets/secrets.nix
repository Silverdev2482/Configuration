let
  publicKeys = [
    # Main
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqkTEWoMAwLrRj7Ju1NDu/cKhp0yH/qywsKg57mhq0a"
    # Desktop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJigoOU3n5490/bfnXkrTnUA5RUX2AoxC9CjAjgSXnDD"
    # Router 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhD4eNd9XoRcD91v6PwmKq/BkYyMr7mNKXTbIEHY/DQ"
    # T14G4
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7kykYlNruAXM9k7P8JsfgWDxzibi644M4PIlB3G1Gj"
  ];

  secrets = [
    "user-password.age"
    "router-vpn-private-key.age"
    "commercial-vpn-private-key.age"
    "commercial-vpn-preshared-key.age"
    "acme-key.age"
    "bind-acme-key.age"
  ];

in  builtins.listToAttrs (map (name: { inherit name; value = { inherit publicKeys; }; }) secrets)
