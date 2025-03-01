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
    
    # Ollama
    ollama.enable = true;
    ollama.acceleration = "cuda";

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
        "homepage.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:3000";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "jellyfin.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:8096";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "torrents.flowers-datacenter.com" = {
          locations = {
            "/".proxyPass = "http://192.168.1.109:8080";
            "/radarr".proxyPass = "http://192.168.1.109:7878";
          };
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "speedtest.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:4000";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "files.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:7920";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "sync.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:8384";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "filebot.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:5800";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "bezsel.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:8090";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "notes.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:3001";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        "photos.flowers-datacenter.com" = {
          locations."/".proxyPass = "http://192.168.1.109:2283";
          useACMEHost = "flowers-datacenter.com";
          forceSSL = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
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
