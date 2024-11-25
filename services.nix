{ config, pkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "master4491@gmail.com";

    certs."flowers-datacenter.com" = {
      domain = "flowers-datacenter.com";
      extraDomainNames = ["*.flowers-datacenter.com"];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = /home/david/cloudflare.secret;
    };
  };

  services = {
    
    # xserver
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    
    # SSH
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      settings.DenyUsers = [ "test" "media" "time-machine" ];
      settings.LoginGraceTime = 0;
      settings.PrintMotd = true;
    };
    
    # Tailscale VPN
    tailscale = {
      enable = true;
    };

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
        "homepage.flowers-datacenter.home" = {
          locations."/".proxyPass = "http://192.168.1.109:3000";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
        };
        "jellyfin.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:8096";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
        };
        "torrents.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:8080";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
        };
        "speedtest.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:4000";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
        };
        "homepage.home".locations."/".proxyPass = "http://192.168.1.109:3000";
        "jellyfin.home".locations."/".proxyPass = "http://192.168.1.109:8096";
        "uptime.home".locations."/".proxyPass = "http://192.168.1.109:7000";
        "bluemap.home".locations."/".proxyPass = "http://192.168.1.109:8100";
        "mc.home".locations."/".proxyPass = "http://192.168.1.109:25565";
      };
      recommendedGzipSettings = true;
    };

  };

  users.users.nginx.extraGroups = [ "acme" ];
  
  # Docker
  virtualisation.docker = {
    enable = true;
    listenOptions = [ "2375" ];
  };
}
