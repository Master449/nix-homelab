{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./samba.nix
      ./services.nix
      ./firewall.nix
      ./systemd.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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

  users.users = {
    david = {
      isNormalUser = true;
      description = "david";
      extraGroups = [ "networkmanager" "wheel" "samba" "docker" "libvirtd" "libvirt" ];
      shell = pkgs.zsh;
      packages = with pkgs; [];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    ffmpeg-full
    jellyfin-ffmpeg
    htop
    git
    nvtopPackages.intel
    fastfetch
    kitty
    curl
    bc
    figlet
    fortune
    lm_sensors
    libvirt
    qemu
    virt-manager
    nodejs_22
    nodePackages_latest.npm
  ];

  programs.zsh.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
