{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./samba.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  nix.nixPath = [
    "/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/david/nix-homelab/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  time.timeZone = "America/Chicago";
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

  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    tailscale = {
      enable = true;
    };
  };

  users.users = {
    david = {
      isNormalUser = true;
      description = "david";
      extraGroups = [ "networkmanager" "wheel" "samba" ];
      packages = with pkgs; [];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    kitty
    htop
    git
  ];

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 22 445 139 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  system.stateVersion = "24.05"; # Did you read the comment?

}
