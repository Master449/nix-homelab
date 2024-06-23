{ config, pkgs, ... }:
{
  services.homepage-dashboard = {
    enable = true;

    services = [{
      "Media" = [
         {
         "Jellyfin" = {
           description = "Jellyfin Media Server";
           href = "http://192.168.5.214:8096/";
         };
        }
      ];
    }];

    bookmarks = [{
      Developer = [{
        GitHub = [{
          abbr = "GH";
          href = "https://github.com/Master449?tab=repositories";
          }];
      }];
    }];

    widgets = [{
      resources = {
        cpu = true;
        disk = "/mnt/WD1";
        memory = true;
      };
    }
    {
      search = {
        provider = "google";
        target = "_blank";
      };
    }];
  };
}
