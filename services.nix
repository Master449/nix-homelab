{ config, pkgs, ... }:
{
  #users.users.nginx.extraGroups = [ "acme" ];

  # Used by nginx, might SSL later down the line
  #security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "master4491@gmail.com";
  #  certs."jellyfin-flowers-1942130.duckdns.org" = {
  #    dnsProvider = "duckdns";
  #    webroot = null;
  #    group = "nginx";
  #    environmentFile = "/home/david/.secrets";
  #  };
  #};

  services = {
    
    # xserver
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    
    # SSH
    openssh = {
      enable = true;
      #settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      settings.DenyUsers = [ "test" "media" "time-machine" ];
      settings.LoginGraceTime = 0;
      settings.PrintMotd = true;
    };
    
    # Tailscale VPN
    tailscale = {
      enable = true;
    };
    
    # Mullvad  VPN
    #mullvad-vpn.enable = true;
    #resolved.enable = true;

    # Jellyfin Media Server
    jellyfin = {
      enable = true;
    };

    # Broadcasts Time Machine Availability
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    
    # Reverse Proxy
    nginx = {
      enable = true;
    
      virtualHosts = {
        "homepage.home".locations."/".proxyPass = "http://localhost:3000";
        "jellyfin.home".locations."/".proxyPass = "http://localhost:8096";
        "torrents.home".locations."/".proxyPass = "http://localhost:9091";
        "uptime.home".locations."/".proxyPass = "http://localhost:7000";
        "bluemap.home".locations."/".proxyPass = "http://localhost:8100";
        "mc.home".locations."/".proxyPass = "http://localhost:25565";
      };
      recommendedGzipSettings = true;
    };
  };
  
  # Docker
  virtualisation.docker = {
    enable = true;
    listenOptions = [ "2375" ];
  };
}
